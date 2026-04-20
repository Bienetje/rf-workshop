*** Settings ***
Documentation       API-testcases voor de campsite API van Praegus Travels.
Library             RequestsLibrary
Library             Collections
Library             DateTime
Suite Setup         Create API Session
Suite Teardown      Cleanup Created Campsite
Test Teardown       Cleanup Created Campsite

*** Variables ***
${BASE_URL}         https://travels.praegus.nl
${SESSION_ALIAS}    api
${CREATED_ID}       ${EMPTY}
@{EXPECTED_CAMPING_NAMES}
...                 Pine Valley Campground
...                 Lakeside Retreat
...                 Desert Oasis
...                 Mountain View
...                 Coastal Hideaway

*** Test Cases ***
API-01 GET all campsites returns expected website campsite names
    [Tags]    api    smoke    get
    ${response}=    GET On Session    ${SESSION_ALIAS}    /api/campsites
    Status Should Be    200    ${response}
    ${all_campsites}=    Evaluate    __import__('json').loads(${response}.content.decode('utf-8'))
    FOR    ${expected}    IN    @{EXPECTED_CAMPING_NAMES}
        ${found}=    Evaluate    any(item.get('name') == '''${expected}''' for item in ${all_campsites})
        Should Be True    ${found}    Campsite '${expected}' not gevonden in API-response
    END

API-02 GET campsite by ID returns Pine Valley Campground
    [Tags]    api    get
    ${response}=    GET On Session    ${SESSION_ALIAS}    /api/campsites/1
    Status Should Be    200    ${response}
    ${campsite}=    Set Variable    ${response.json()}
    Should Be Equal    ${campsite['name']}    Pine Valley Campground
    Should Be Equal    ${campsite['location']}    Yosemite National Park, CA

API-03 POST creates a new campsite successfully
    [Tags]    api    post    smoke
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${name}=    Set Variable    API Test Campsite ${timestamp}
    ${payload}=    Create Dictionary
    ...    name=${name}
    ...    location=Test Valley, TX
    ...    description=Test campsite created by API smoke test.
    ...    pricePerNight=42.0
    ...    capacity=3
    ...    amenities=BBQ, Water, Fire pit
    ...    imageUrl=https://example.com/test-campsite.jpg
    ...    available=True
    ...    campsiteType=tent
    ...    terrainType=forest
    ...    accessibilityLevel=moderate
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/campsites    json=${payload}
    Status Should Be    201    ${response}
    ${created}=    Set Variable    ${response.json()}
    Should Be Equal    ${created['name']}    ${name}
    Should Be True    ${created['id']} > 0
    Set Suite Variable    ${CREATED_ID}    ${created['id']}
    ${get_response}=    GET On Session    ${SESSION_ALIAS}    /api/campsites/${CREATED_ID}
    Status Should Be    200    ${get_response}
    ${loaded}=    Set Variable    ${get_response.json()}
    Should Be Equal    ${loaded['name']}    ${name}
    Should Be Equal As Strings    ${loaded['available']}    True

*** Keywords ***
Create API Session
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)
    Create Session    ${SESSION_ALIAS}    ${BASE_URL}    verify=False

Cleanup Created Campsite
    Run Keyword If    '${CREATED_ID}' != ''    Run Keyword And Ignore Error    DELETE On Session    ${SESSION_ALIAS}    /api/campsites/${CREATED_ID}
    Set Suite Variable    ${CREATED_ID}    ${EMPTY}
