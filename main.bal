import ballerinax/mysql;
import ballerinax/mysql.driver as _; // This bundles the driver to the project so that you don't need to bundle it via the `Ballerina.toml` file.
import ballerina/sql;

public type Customer record {|
    int id?;
    string book_reference;
    string customer_id;
    string flight_number;
    string flight_from;
    string flight_to;
    string passenger_name;
    int flight_distance;
    string seat_number;
|};

public type CheckInEntry record {|
    string flight_number;
    string seat_number;
    string passenger_name;
    string customer_id;
    string flight_from;
    string flight_to;
    int flight_distance;
|};

public type FlyerMilesEntry record {|
    int flight_distance;
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new (
    host = HOST, user = USER, password = PASSWORD, database = DATABASE
);

isolated function addCustomer(Customer cus) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO qatar_airways_tb (id, book_reference, customer_id, flight_number, flight_from,
                               flight_to, passenger_name, flight_distance, seat_number)
        VALUES (${cus.id}, ${cus.book_reference}, ${cus.customer_id},  
                ${cus.flight_number}, ${cus.flight_from}, ${cus.flight_to}, ${cus.passenger_name},
                ${cus.flight_distance}, ${cus.seat_number})
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

isolated function getCustomer(string passenger_name, string book_reference) returns CheckInEntry|error {
    CheckInEntry customer = check dbClient->queryRow(
        `SELECT qatar_airways_tb.flight_number, qatar_airways_tb.seat_number, qatar_airways_tb.passenger_name, qatar_airways_tb.customer_id, qatar_airways_tb.flight_from, qatar_airways_tb.flight_to, qatar_airways_tb.flight_distance FROM qatar_airways_tb WHERE passenger_name = ${passenger_name} AND book_reference = ${book_reference}`
    );
    return customer;
}

