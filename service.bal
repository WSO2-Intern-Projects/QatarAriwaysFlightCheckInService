import ballerina/http;

public type PostEntry record {|
    string bookReference;
    string passengerName;
|};

service /customers on new http:Listener(7070) {

    resource function post checkIn(@http:Payload PostEntry postEntry) returns json|error? {

        // return getCustomer(passengerName, bookReference);
        CheckInEntry|error originalResponse = getCustomer(postEntry.passengerName, postEntry.bookReference);

        if (originalResponse is CheckInEntry) {
            // Create a new JSON object with renamed keys
            return {
                    "flightNumber": originalResponse.flight_number,
                    "seatNumber": originalResponse.seat_number,
                    "passengerName": originalResponse.passenger_name,
                    "customerId": originalResponse.customer_id,
                    "flightDistance": originalResponse.flight_distance,
                    "fromWhere": originalResponse.flight_from,
                    "whereTo": originalResponse.flight_to
                    };
        } else {
            return {
                    "flight_number": "null",
                    "seat_number": "null",
                    "passenger_name": "null",
                    "customer_id": "null",
                    "flightDistance": 0,
                    "fromWhere": "null",
                    "whereTo": "null"
                };
        }

        // Create a new JSON object with a "response" field

        // json responseJson = {
        //     "checkInInfo": check getCustomer(passengerName, bookReference)
        // };

        // // Return the new JSON object as the response
        // return responseJson;
    }
}

