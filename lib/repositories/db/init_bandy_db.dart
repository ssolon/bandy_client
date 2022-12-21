import 'package:bandy_client/repositories/db/kaleidalog_sqlite.dart';
import 'package:sqflite/sqflite.dart';

const sessionTypeUUID = '6d2389ec-9840-44a7-acc9-121084930f20';
const exerciseTypeUUID = '24dc325f-c97b-4a87-bfb6-f82c3616e511';
const workoutSetTypeUUID = 'fe15ec3e-d3d2-4dca-b577-69ab090a1c78';
const exerciseRepTypeUUID = '8f0ea171-22b8-4b37-8cfc-a03bd42187d0';

class InitBandyDatabase extends KaleidaLogDb {
  InitBandyDatabase([super.databaseName]);

  static const bandyTagUUID = '8066357a-cd82-4c4c-aecf-af50387db0f6';
  static const exerciseTagUUID = 'f9fe07a4-f19c-4350-8172-6f551957a085';

  static const exerciseTags = [bandyTagUUID, exerciseTagUUID];

  @override
  initTags(Database db) {
    createTag(db, bandyTagUUID, 'bandy', null);
    createTag(db, exerciseTagUUID, 'exercise', null);
  }

  // Exercise events

  static const inclinePressUUID = '98d4a033-8a77-402a-878c-95724e89a2f6';
  static const chestPressUUID = '0e54a316-13d9-4173-91f9-839703a94514';
  static const declinePressUUID = 'cd611147-43d7-4bf2-9d32-b57dbe2a8d0b';
  static const flyUUID = '88a76883-1f85-4222-bf40-5adafd301c9f';
  static const hammerCurlUUID = 'e9b41ac5-95d5-4802-940a-7bcbe5d8e7c6';
  static const barCurlUUID = '6c3b8afc-7023-457c-b428-927192ebbc1b';
  static const ropePullDownUUID = '4bcdbf01-6026-4124-b223-887c2d1f8656';
  static const barPullDownUUID = 'c8f77f5d-efcd-452f-9b1a-3c199643fdb1';
  static const goodMorningUUID = '737ae21f-7873-4e9d-959e-8a6e6f644f52';
  static const chestUpCrossUUID = '90c2d7fe-5017-497e-86df-e6e7209496ce';
  @override
  initEventTypes(Database db) {
    createEventType(
        db, sessionTypeUUID, 'Session', 'Start of session', [bandyTagUUID]);
    createEventType(
        db, exerciseTypeUUID, 'Exercise', 'Undefined exercise', exerciseTags);
    createEventType(db, workoutSetTypeUUID, 'WorkoutSet',
        'Multiple reps of same exericise', [bandyTagUUID]);
    createEventType(db, exerciseRepTypeUUID, 'Rep', 'Single rep of an exercise',
        [bandyTagUUID]);

    // Start out with some exercises

    createEventType(db, inclinePressUUID, 'Incline Press', null, exerciseTags);
    createEventType(db, chestPressUUID, 'Chest Press', null, exerciseTags);
    createEventType(db, declinePressUUID, 'Decline Press', null, exerciseTags);
    createEventType(db, flyUUID, 'Chest Fly', null, exerciseTags);
    createEventType(db, hammerCurlUUID, 'Hammer Curl', null, exerciseTags);
    createEventType(db, barCurlUUID, 'Bar Curl', null, exerciseTags);
    createEventType(db, ropePullDownUUID, 'Rope Pull Down', 'Triceps pull down',
        exerciseTags);
    createEventType(db, barPullDownUUID, 'Bar Pull Down', 'Triceps pull down',
        exerciseTags);
    createEventType(db, goodMorningUUID, 'Good Morning', null, exerciseTags);
    createEventType(db, chestUpCrossUUID, 'Chest Up Cross', null, exerciseTags);
  }
}
