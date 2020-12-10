import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_database/objects/event_object.dart';
import 'package:rotary_database/objects/event_populated_object.dart';
import 'package:rotary_database/services/globals_service.dart';
import 'package:rotary_database/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class EventService {

  //#region Create Event As Object
  //=============================================================================
  EventObject createEventAsObject(
      String aEventId,
      String aEventName,
      String aEventPictureUrl,
      String aEventDescription,
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime,
      String aEventLocation,
      String aEventManager,
      String aEventComposerId,
      )
  {
    if (aEventId == null)
      return EventObject(
          eventId: '',
          eventName: '',
          eventPictureUrl: '',
          eventDescription: '',
          eventStartDateTime: null,
          eventEndDateTime: null,
          eventLocation: '',
          eventManager: '',
          eventComposerId: ''
      );
    else
      return EventObject(
          eventId: aEventId,
          eventName: aEventName,
          eventPictureUrl: aEventPictureUrl,
          eventDescription: aEventDescription,
          eventStartDateTime: aEventStartDateTime,
          eventEndDateTime: aEventEndDateTime,
          eventLocation: aEventLocation,
          eventManager: aEventManager,
          eventComposerId: aEventComposerId,
      );
  }
  //#endregion

  //#region Create Event Populated As Object
  //=============================================================================
  EventPopulatedObject createEventPopulatedAsObject(
      String aEventId,
      String aEventName,
      String aEventPictureUrl,
      String aEventDescription,
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime,
      String aEventLocation,
      String aEventManager,
      String aEventComposerId,
      String aComposerFirstName,
      String aComposerLastName,
      String aComposerEmail,
      String aAreaId,
      String aAreaName,
      String aClusterId,
      String aClusterName,
      String aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aClubManagerId,
      String aRoleId,
      int aRoleEnum,
      String aRoleName
      )
  {
    if (aEventId == null)
      return EventPopulatedObject(
          eventId: '',
          eventName: '',
          eventPictureUrl: '',
          eventDescription: '',
          eventStartDateTime: null,
          eventEndDateTime: null,
          eventLocation: '',
          eventManager: '',
          eventComposerId: '',
          composerFirstName: '',
          composerLastName: '',
          composerEmail: '',
          areaId: null,
          areaName: '',
          clusterId: null,
          clusterName: '',
          clubId: null,
          clubName: '',
          clubAddress: '',
          clubMail: '',
          clubManagerId: '',
          roleId: '',
          roleEnum: null,
          roleName: ''
      );
    else
      return EventPopulatedObject(
          eventId: aEventId,
          eventName: aEventName,
          eventPictureUrl: aEventPictureUrl,
          eventDescription: aEventDescription,
          eventStartDateTime: aEventStartDateTime,
          eventEndDateTime: aEventEndDateTime,
          eventLocation: aEventLocation,
          eventManager: aEventManager,
          eventComposerId: aEventComposerId,
          composerFirstName: aComposerFirstName,
          composerLastName: aComposerLastName,
          composerEmail: aComposerEmail,
          areaId: aAreaId,
          areaName: aAreaName,
          clusterId: aClusterId,
          clusterName: aClusterName,
          clubId: aClubId,
          clubName: aClubName,
          clubAddress: aClubAddress,
          clubMail: aClubMail,
          clubManagerId: aClubManagerId,
          roleId: aRoleId,
          roleEnum: aRoleEnum,
          roleName: aRoleName
      );
  }
  //#endregion

  //#region * Get Events List By Search Query [GET]
  // =========================================================
  Future getEventsListBySearchQuery(String aValueToSearch) async {
    try {
      String _getUrlEvent = GlobalsService.applicationServer + Constants.rotaryEventUrl + "/query/$aValueToSearch";
      Response response = await get(_getUrlEvent);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        var eventList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<EventObject> eventObjList = eventList.map((eventJson) => EventObject.fromJson(eventJson)).toList();

        return eventObjList;
      } else {
        print('<EventService> Get Events List By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      developer.log(
        'getEventsListBySearchQuery',
        name: 'EventService',
        error: 'Get Events List By SearchQuery >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Events List Populated By Search Query [GET]
  // =========================================================
  Future getEventsListPopulatedBySearchQuery(String aValueToSearch) async {
    try {
      String _getUrlEvent = GlobalsService.applicationServer + Constants.rotaryEventUrl + "/query/$aValueToSearch/populated";
      Response response = await get(_getUrlEvent);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        var eventList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<EventPopulatedObject> eventObjList = eventList.map((eventJson) => EventPopulatedObject.fromJsonAllPopulated(eventJson)).toList();

        return eventObjList;
      } else {
        print('<EventService> Get Events List Populated By Search Query >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      developer.log(
        'getEventsListPopulatedBySearchQuery',
        name: 'EventService',
        error: 'Get Events List Populated By Search Query >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Events

  //#region * Insert Event [WriteToDB]
  //=============================================================================
  Future insertEvent(EventObject aEventObj) async {
    try {
      String jsonToPost = aEventObj.eventToJson(aEventObj);

      String _insertUrlEvent = GlobalsService.applicationServer + Constants.rotaryEventUrl;
      Response response = await post(_insertUrlEvent, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        final Map parsedResponse = json.decode(jsonResponse);
        EventObject insertedEventObject = EventObject.fromJson(parsedResponse);

        return insertedEventObject;
      } else {
        print('<EventService> Insert Event >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      developer.log(
        'insertEvent',
        name: 'EventService',
        error: 'Insert Event >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update Event By Id [WriteToDB]
  //=============================================================================
  Future updateEventById(EventObject aEventObj) async {
    try {
      // Convert EventObject To Json
      String jsonToPost = aEventObj.eventToJson(aEventObj);

      String _updateUrlEvent = GlobalsService.applicationServer + Constants.rotaryEventUrl + "/${aEventObj.eventId}";
      Response response = await put(_updateUrlEvent, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        return jsonResponse;
      } else {
        print('<EventService> Update Event By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      developer.log(
        'updateEventById',
        name: 'EventService',
        error: 'Update Event By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update Event Image Url By Id [WriteToDB]
  //=============================================================================
  Future updateEventImageUrlById(String aEventId, String aEventImageUrl) async {
    try {
      Map bodyParams = {
        "eventImageUrl": aEventImageUrl
      };

      String _updateUrlEvent = GlobalsService.applicationServer + Constants.rotaryEventUrl + "/$aEventId/updateEventImage";
      Response response = await put(_updateUrlEvent, body: bodyParams);

      if (response.statusCode <= 300) {
        // Map<String, String> headers = response.headers;
        // String contentType = headers['content-type'];
        String jsonResponse = response.body;

        return jsonResponse;
      } else {
        print('<EventService> Update Event Image Url By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      developer.log(
        'updateEventImageUrlById',
        name: 'EventService',
        error: 'Update Event Image Url By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
