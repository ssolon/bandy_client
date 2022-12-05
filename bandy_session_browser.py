#!/usr/bin/env python
# coding: utf-8

import sys
import sqlite3
import datetime
import json
from matplotlib import pyplot as plt

#get_ipython().run_line_magic('matplotlib', 'widget')

def convert_date(val):
    return datetime.date.fromisoformat(val.decode())
def convert_datetime(val):
    return datetime.datetime.fromisoformat(val.decode())
def convert_timestamp(val):
    return datetime.datetime.fromtimestamp(int(val))

def delta_formatter(delta :datetime.timedelta):
    seconds = delta.total_seconds()


# Event types by level from recursive query

SESSION_LEVEL = 1
WORKOUT_SET_LEVEL = 2
REP_LEVEL = 3

class SetCounter:
    def __init__(self) -> None:
        self.counts = {}

    def count_for(self, exercise_name:str):
        try:
            self.counts[exercise_name] = self.counts[exercise_name] + 1
        except KeyError:
            pass

        return self.counts.setdefault(exercise_name, 1)

def shortformat(d :datetime.datetime):
    return datetime.datetime.isoformat(d, timespec='minutes')

def main():
    sqlite3.register_converter("date", convert_date)
    sqlite3.register_converter("datetime", convert_datetime)
    sqlite3.register_converter("timestamp", convert_timestamp)

    db_path = "/Users/samsolon/IdeaProjects/bandy_client/kaleidalog.db"
    con = sqlite3.connect(db_path, detect_types=sqlite3.PARSE_DECLTYPES|sqlite3.PARSE_COLNAMES)
    con.row_factory = sqlite3.Row

    # Get all the sessions and select one

    cur = con.cursor()
    sessions_cursor = cur.execute("""SELECT e.event_id, e.event_at, et.event_type_name 
                    FROM events e
                    JOIN event_types et USING(event_type_id)
                    WHERE et.event_type_name = 'Session'""")

    sessions = sessions_cursor.fetchall()
    for i in range(len(sessions)):
        print(i, sessions[i][0], sessions[i][1])
        
    print('Select session:')
    selection_index = input()

    session = sessions[int(selection_index)]
    selected_session_id = session[0]
    set_counter = SetCounter()
    title = session[2] + ' ' + shortformat(session[1])
    print("You selected %s " %(selected_session_id))

    # Fetch all events for the session
     
    workout_result = cur.execute("""
    WITH RECURSIVE workout AS (
    SELECT e.event_id, e.event_type_id, et.event_type_name, e.event_at, e.event_parent_id, e.event_details, 1 as level
        FROM events e
        JOIN event_types et USING(event_type_id)
        WHERE event_id = ?
    UNION ALL
    SELECT this.event_id, this.event_type_id, et.event_type_name, this.event_at, this.event_parent_id, this.event_details, level + 1
        FROM events this
        JOIN event_types et USING(event_type_id)
        INNER JOIN workout prior ON this.event_parent_id = prior.event_id
    )
    SELECT w.event_type_name, w.event_at, w.level, w.event_details
    FROM workout w
    ORDER BY w.event_at
    """, [selected_session_id])

    workout = workout_result.fetchall()

    # Create an index into workout for each set

    set_indexes = []
    set_descriptions = []
    set_counter = SetCounter()

    for index, r in enumerate(workout):
        d = dict(r)
        level = d['level']
        details = json.loads(d['event_details'])
        indent = '    ' * (level - 1)
        if level in [SESSION_LEVEL, WORKOUT_SET_LEVEL]:
            if level == WORKOUT_SET_LEVEL:
                set_indexes.append(index)
            print(indent, d['event_type_name'], d['event_at'], details.get('count', ''), details)
        else: # Should be rep
            if len(set_descriptions) < len(set_indexes): # need to add the exercise
                exercise_name = d['event_type_name']
                description = f"{exercise_name} #{set_counter.count_for(exercise_name)}"
                print(description)
                set_descriptions.append(description)
            # print(indent, details)

    # Start at beginning of set_indexes
    # plt.ion()
    set_index = 0 
    
    # Create a figure so we can set the title

    fig = plt.figure(title)

    # Handle key presses

    def beep():
        print('Beep!\07')

    def on_press(event):
        nonlocal set_index
        nonlocal set_indexes
        nonlocal workout

        key = event.key
        next_index = None

        print('pressed', key)
        if key == 'right':
            if set_index < len(set_indexes)-1:
                next_index = set_index + 1
            else:
                beep()
        elif key == 'left':
            if set_index > 0:
                next_index = set_index - 1
            else:
                beep()
        elif key == 'q': 
            plt.close()
        else:
            print(f"Some other key={key}")

        print(f"next_index={next_index} set_index={set_index}")
        if next_index != None:
            set_index = next_index
            plot_set(workout[set_indexes[set_index]:], dict(workout[0]), set_descriptions[set_index])
        else:
            plt.show() # Keeps from ending when we don't do another plot.

    fig.canvas.mpl_connect('key_press_event', on_press)
    key_pressed = plot_set(workout, dict(workout[0]), set_descriptions[0])

    print(f"Done with {key_pressed} !!!!")

    con.close()

def plot_set(events: list, session_event, set_description :str):
    """Plot a single set starting at starting_index in workout."""
    plot_sets = []
    subtitle = ''

    for i, w in enumerate(events):
        d = dict(w)
        level = d['level']
        
        if level == WORKOUT_SET_LEVEL: # Start workoutSet
            set_details=json.loads(d['event_details'])
            rep_count = set_details['count']
            set_start = d['event_at']

            for r in events[i+1:]:
                d = dict(r)
                level = d['level']

                if level < REP_LEVEL:
                    break # Done with this set of reps

                plot_sets.append({
                        'name': d['event_type_name'],
                        'exercise': None,
                        'xvals': [],
                        'yvals': [],
                })


                # Set up the subtitle from the first rep

                if not subtitle:
                    exercise_name = d['event_type_name']
                    subtitle = (f"{set_description} - {rep_count} reps")

                # Add the rep

                details = json.loads(d['event_details'])
                for i in details['reps']['instants']:
                    rep_start = datetime.datetime.fromisoformat(i['when'])
                    delta = (rep_start - set_start)
                    millis = delta.seconds*1000 + delta.microseconds / 1000
                    plot_sets[-1]['xvals'].append(millis)
                    plot_sets[-1]['yvals'].append(i['reading'])

            # Clear anything previous

            plt.clf()

            # Set the titles

            plt.suptitle(subtitle)
            plt.xlabel('millis')
            plt.ylabel('pounds')

            # Draw the plot            

            for s in plot_sets:
                plt.plot(s['xvals'], s['yvals'], '.', label=s['name'])

            print('Show the plot')

            plt.show(block=False)
            plt.draw_all()

            print("Continuing!")
            return plt.waitforbuttonpress()
            

if __name__ == "__main__":
    main()