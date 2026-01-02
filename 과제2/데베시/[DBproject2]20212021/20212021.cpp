#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include "mysql.h"
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <iomanip>

#pragma comment(lib, "libmysql.lib")

const char* host = "localhost";
const char* user = "root";
const char* password = "wdhwswkes12!";
const char* database = "project";

using namespace std;

vector<string> dropStatements;  // DROP TABLE 명령문을 저장할 벡터

// 데이터베이스 연결 초기화
MYSQL* initializeConnection() {
    MYSQL* conn = mysql_init(NULL);
    if (conn == NULL) {
        printf("mysql_init() failed!\n");
        return NULL;
    }
    conn = mysql_real_connect(conn, host, user, password, NULL, 3306, NULL, 0);
    if (conn == NULL) {
        printf("Connection Error %d: %s\n", mysql_errno(conn), mysql_error(conn));
    }
    return conn;
}

// CRUD 파일 실행
void executeCrudFile(MYSQL* conn, const char* filepath) {
    ifstream file(filepath);
    if (!file.is_open()) {
        printf("Failed to open CRUD file.\n");
        return;
    }
    string line;
    bool isInDropSection = false;

    while (getline(file, line)) {
        if (line.find("DROP TABLE IF EXISTS") != string::npos) {
            isInDropSection = true;
            dropStatements.push_back(line);
            continue;
        }

        if (!isInDropSection) {
            if (!line.empty()) {
                if (mysql_query(conn, line.c_str())) {
                    printf("Query Error: %s\n", mysql_error(conn));
                    printf("Failed Query: %s\n", line.c_str());
                }
            }
        }
    }
    file.close();
}

// 쿼리 실행 및 결과 출력
void executeAndDisplayQuery(MYSQL* conn, const string& query, bool showHeader) {
    if (mysql_query(conn, query.c_str())) {
        cerr << "Query Error: " << mysql_error(conn) << '\n';
        return;
    }
    MYSQL_RES* result = mysql_store_result(conn);
    if (result) {
        MYSQL_ROW row;
        unsigned int num_fields = mysql_num_fields(result);
        MYSQL_FIELD* fields = mysql_fetch_fields(result);

        if (showHeader) {
            for (unsigned int i = 0; i < num_fields; i++) {
                cout << left << setw(32) << ("[" + string(fields[i].name) + "]");
            }
            cout << '\n';
        }

        while ((row = mysql_fetch_row(result))) {
            for (unsigned int i = 0; i < num_fields; i++) {
                cout << left << setw(32) << (row[i] ? row[i] : "NULL");
            }
            cout << '\n';
        }
        mysql_free_result(result);
    }
}

// TYPE 1 쿼리 처리
void handleType1Queries(MYSQL* conn) {
    string query = "SELECT property_address FROM property WHERE property_address LIKE '%Mapo%';";
    executeAndDisplayQuery(conn, query, true);

    int choice;
    while (true) {
        cout << "\n------- Subtypes in TYPE 1 -------\n";
        cout << "       1. TYPE 1-1\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            query = "SELECT property_address FROM property WHERE property_cost BETWEEN 1000000000 AND 1500000000 AND property_address LIKE '%Mapo%';";
            executeAndDisplayQuery(conn, query, true);
            return;
        default:
            cout << "Invalid choice. Please try again.\n";
        }
    }
}

// TYPE 2 쿼리 처리
void handleType2Queries(MYSQL* conn) {
    string query = "SELECT property_address FROM property WHERE school_district_number = 8;";
    executeAndDisplayQuery(conn, query, true);

    int choice;
    while (true) {
        cout << "\n------- Subtypes in TYPE 2 -------\n";
        cout << "       1. TYPE 2-1\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            query = "SELECT property_address FROM property WHERE property_address LIKE '%Seoul Jongno%';";
            executeAndDisplayQuery(conn, query, true);
            return;
        default:
            cout << "Invalid choice. Please try again.\n";
        }
    }
}

// TYPE 3 쿼리 처리
void handleType3Queries(MYSQL* conn) {
    string query = "SELECT a.agent_name, SUM(s.sale_price) AS TotalSales "
        "FROM agent a JOIN sales s ON a.agent_id = s.agent_id "
        "WHERE YEAR(s.sale_date) = 2022 "
        "GROUP BY a.agent_id "
        "ORDER BY TotalSales DESC "
        "LIMIT 1;";
    executeAndDisplayQuery(conn, query, true);

    int choice;
    while (true) {
        cout << "\n------- Subtypes in TYPE 3 -------\n";
        cout << "       1. TYPE 3-1\n";
        cout << "       2. TYPE 3-2\n\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1: {
            cout << "\n------- TYPE 3-1 --------\n";
            int k;
            cout << "\n** Find the top k agents in 2023 by total sales value. **\n";
            cout << " Enter K: ";
            cin >> k;
            cout << '\n';
            query = "SELECT a.agent_name, SUM(s.sale_price) AS TotalSales "
                "FROM agent a JOIN sales s ON a.agent_id = s.agent_id "
                "WHERE YEAR(s.sale_date) = 2023 "
                "GROUP BY a.agent_id "
                "ORDER BY TotalSales DESC "
                "LIMIT " + to_string(k) + ";";
            executeAndDisplayQuery(conn, query, true);
            return;
        }
        case 2: {
            cout << '\n';
            string countQuery = "SELECT ROUND(COUNT(DISTINCT a.agent_id) * 0.1) AS Bottom10PercentCount "
                "FROM agent a JOIN sales s ON a.agent_id = s.agent_id "
                "WHERE YEAR(s.sale_date) = 2021;";
            if (mysql_query(conn, countQuery.c_str())) {
                printf("Query Error: %s\n", mysql_error(conn));
                return;
            }
            MYSQL_RES* result = mysql_store_result(conn);
            if (!result) {
                printf("Result Error: %s\n", mysql_error(conn));
                return;
            }
            MYSQL_ROW row = mysql_fetch_row(result);
            if (!row) {
                printf("Fetch Error: %s\n", mysql_error(conn));
                mysql_free_result(result);
                return;
            }
            int bottom10PercentCount = stoi(row[0] ? row[0] : "0");
            mysql_free_result(result);

            query = "SELECT agent_name, SUM(s.sale_price) AS TotalSales "
                "FROM agent a JOIN sales s ON a.agent_id = s.agent_id "
                "WHERE YEAR(s.sale_date) = 2021 "
                "GROUP BY a.agent_id "
                "ORDER BY TotalSales ASC "
                "LIMIT " + to_string(bottom10PercentCount) + ";";
            executeAndDisplayQuery(conn, query, true);
            return;
        }
        default:
            cout << "Invalid choice. Please try again.\n";
        }
    }
}

// TYPE 4 쿼리 처리
void handleType4Queries(MYSQL* conn) {
    string query = "SELECT a.agent_name, AVG(s.sale_price) AS AvgSalePrice, AVG(DATEDIFF(p.end_time, s.sale_date)) AS AvgMarketTime "
        "FROM agent a JOIN deal d ON a.agent_id = d.agent_id "
        "JOIN property p ON d.property_id = p.property_id "
        "JOIN sales s ON p.property_id = s.property_id "
        "WHERE YEAR(s.sale_date) = 2022 "
        "GROUP BY a.agent_id;";
    executeAndDisplayQuery(conn, query, true);

    int choice;
    while (true) {
        cout << "\n------- Subtypes in TYPE 4 -------\n";
        cout << "       1. TYPE 4-1\n";
        cout << "       2. TYPE 4-2\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            query = "SELECT a.agent_name, MAX(s.sale_price) AS MaxSalePrice "
                "FROM agent a JOIN deal d ON a.agent_id = d.agent_id "
                "JOIN property p ON d.property_id = p.property_id "
                "JOIN sales s ON p.property_id = s.property_id "
                "WHERE YEAR(s.sale_date) = 2023 "
                "GROUP BY a.agent_id;";
            executeAndDisplayQuery(conn, query, true);
            break;
        case 2:
            query = "SELECT a.agent_name, MAX(DATEDIFF(p.end_time, s.sale_date)) AS LongestMarketTime "
                "FROM agent a JOIN deal d ON a.agent_id = d.agent_id "
                "JOIN property p ON d.property_id = p.property_id "
                "JOIN sales s ON p.property_id = s.property_id "
                "GROUP BY a.agent_id;";
            executeAndDisplayQuery(conn, query, true);
            return;
        default:
            cout << "Invalid choice. Please try again.\n";
        }
    }
}

// TYPE 5 쿼리 처리
void handleType5Queries(MYSQL* conn) {
    string query;

    query = "SELECT ph.photo_id, p.property_id, p.floor_plan_number, ph.interior_photo "
        "FROM photo ph JOIN property p ON ph.property_id = p.property_id "
        "WHERE p.floor_plan_number = 'studio' "
        "ORDER BY p.property_cost DESC LIMIT 1;";
    executeAndDisplayQuery(conn, query, true);

    query = "SELECT ph.photo_id, p.property_id, p.floor_plan_number, ph.interior_photo "
        "FROM photo ph JOIN property p ON ph.property_id = p.property_id "
        "WHERE p.floor_plan_number = 'one-bedroom' "
        "ORDER BY p.property_cost DESC LIMIT 1;";
    executeAndDisplayQuery(conn, query, false);

    query = "SELECT ph.photo_id, p.property_id, p.floor_plan_number, ph.interior_photo "
        "FROM photo ph JOIN property p ON ph.property_id = p.property_id "
        "WHERE p.floor_plan_number = 'multi-bedroom' "
        "ORDER BY p.property_cost DESC LIMIT 1;";
    executeAndDisplayQuery(conn, query, false);

    query = "SELECT ph.photo_id, p.property_id, p.floor_plan_number, ph.interior_photo "
        "FROM photo ph JOIN property p ON ph.property_id = p.property_id "
        "WHERE p.floor_plan_number = 'detached' "
        "ORDER BY p.property_cost DESC LIMIT 1;";
    executeAndDisplayQuery(conn, query, false);
}

// TYPE 6 쿼리 처리
void handleType6Queries(MYSQL* conn) {
    cout << "\nTYPE 6 - Record a sale:\n";
    string saleID, propertyID, salePrice, saleDate, buyerID, agentID;
    cout << "Enter SaleID: ";
    cin >> saleID;
    cout << "Enter PropertyID: ";
    cin >> propertyID;
    cout << "Enter SalePrice: ";
    cin >> salePrice;
    cout << "Enter SaleDate (YYYY-MM-DD): ";
    cin >> saleDate;
    cout << "Enter BuyerID: ";
    cin >> buyerID;
    cout << "Enter AgentID: ";
    cin >> agentID;
    string query = "INSERT INTO sales (sale_id, property_id, sale_price, sale_date, buyer_id, agent_id) "
        "VALUES ('" + saleID + "', '" + propertyID + "', '" + salePrice + "', '" + saleDate + "', '" + buyerID + "', '" + agentID + "');";
    executeAndDisplayQuery(conn, query, true);
}

// TYPE 7 쿼리 처리
void handleType7Queries(MYSQL* conn) {
    cout << "\nTYPE 7 - Add a new agent:\n";
    string agentID, agentName, phoneNumber;
    cout << "Enter AgentID: ";
    cin >> agentID;
    cout << "Enter AgentName: ";
    cin.ignore();
    getline(cin, agentName);
    cout << "Enter PhoneNumber: ";
    cin >> phoneNumber;
    string query = "INSERT INTO agent (agent_id, agent_name, agent_phone_number) "
        "VALUES ('" + agentID + "', '" + agentName + "', '" + phoneNumber + "');";
    executeAndDisplayQuery(conn, query, true);
}

// 메인 메뉴 표시 및 선택 처리
void displayMainMenu(MYSQL* conn) {
    int choice;
    while (true) {
        cout << "\n---------- SELECT QUERY TYPES ----------\n\n";
        cout << "           1. TYPE 1\n";
        cout << "           2. TYPE 2\n";
        cout << "           3. TYPE 3\n";
        cout << "           4. TYPE 4\n";
        cout << "           5. TYPE 5\n";
        cout << "           6. TYPE 6\n";
        cout << "           7. TYPE 7\n";
        cout << "           0. Exit\n\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            handleType1Queries(conn);
            break;
        case 2:
            handleType2Queries(conn);
            break;
        case 3:
            handleType3Queries(conn);
            break;
        case 4:
            handleType4Queries(conn);
            break;
        case 5:
            handleType5Queries(conn);
            break;
        case 6:
            handleType6Queries(conn);
            break;
        case 7:
            handleType7Queries(conn);
            break;
        case 0:
            // 종료 전 DROP TABLE 명령어 실행
            for (const string& dropStatement : dropStatements) {
                if (mysql_query(conn, dropStatement.c_str())) {
                    printf("Query Error: %s\n", mysql_error(conn));
                    printf("Failed Query: %s\n", dropStatement.c_str());
                }
            }
            return;
        default:
            cout << "Invalid choice. Please try again.\n";
        }
    }
}

// 메인 함수
int main() {
    MYSQL* conn = initializeConnection();
    if (conn == NULL) {
        printf("Failed to connect to the database.\n");
        return 1;
    }

    // CRUD 파일 실행
    executeCrudFile(conn, "CRUD.txt");

    // 데이터베이스 선택
    if (mysql_select_db(conn, database)) {
        printf("Database selection error %d: %s\n", mysql_errno(conn), mysql_error(conn));
        return 1;
    }
    // 메인 메뉴 표시 및 선택 처리
    displayMainMenu(conn);
    // 연결 종료
    mysql_close(conn);
    return 0;
}
