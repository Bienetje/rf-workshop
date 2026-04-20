*** Settings ***
Documentation       Geautomatiseerde Robot Framework testcases voor Add New Campsite.
...                 Dekking: TC-01 t/m TC-33 uit testplan.
Library             SeleniumLibrary
Suite Setup         Open Browser Naar Nieuw Formulier
Suite Teardown      Sluit Browser Veilig
Test Setup          Ga Naar Nieuw Formulier
Test Teardown       Cleanup Na Test

*** Variables ***
${BASIS_URL}                        %{BASE_URL=https://travels.praegus.nl}
${PAD_NIEUW}                        /campsites/new
${PAD_LIJST}                        /campsites
${BROWSER}                          chrome
${AANGEMAAKTE_CAMPSITE}             ${EMPTY}

${VELD_NAME}                        id=name
${VELD_LOCATION}                    id=location
${VELD_PRICE}                       id=pricePerNight
${VELD_CAPACITY}                    id=capacity
${VELD_CAMPSITE_TYPE}               id=campsiteType
${VELD_TERRAIN_TYPE}                id=terrainType
${VELD_ACCESSIBILITY_LEVEL}         id=accessibilityLevel
${VELD_DESCRIPTION}                 id=description
${VELD_AMENITIES}                   id=amenities
${VELD_IMAGE_URL}                   id=imageUrl

${KNOP_SUBMIT}                      xpath=//button[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'submit') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'save') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'opslaan') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'create campsite')]
${KNOP_CANCEL}                      xpath=(//a[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'cancel') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'annuleren') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'back to campsites')])[1] | (//button[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'cancel') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'annuleren')])[1]

*** Test Cases ***
TC-01 @smoke submit staat uit bij lege verplichte velden
    [Tags]    smoke    p0
    Element Should Be Disabled    ${KNOP_SUBMIT}

TC-02 @smoke submit staat aan bij geldige verplichte velden
    [Tags]    smoke    p0
    Vul Geldige Verplichte Velden
    Element Should Be Enabled    ${KNOP_SUBMIT}

TC-03 @smoke happy path save, redirect en succesmelding
    [Tags]    smoke    regressie    p0
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc03
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}
    Page Should Contain Any    success    succes    saved    opgeslagen
    Page Should Contain    ${naam}

TC-04 name is verplicht
    [Tags]    regressie    p0
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    name

TC-05 location is verplicht
    [Tags]    regressie    p0
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_LOCATION}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    location

TC-06 price accepteert grenswaarde 0
    [Tags]    regressie    grenswaarde    p0
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_PRICE}    0
    Element Should Be Enabled    ${KNOP_SUBMIT}

TC-07 price onder 0 geeft fout
    [Tags]    regressie    negatief    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_PRICE}    -1
    Klik Submit
    Pagina Bevat Fouttekst    price

TC-08 price niet numeriek geeft fout
    [Tags]    regressie    negatief    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_PRICE}    abc
    Klik Submit
    Pagina Bevat Fouttekst    price

TC-09 capacity accepteert grenswaarde 1
    [Tags]    regressie    grenswaarde    p0
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_CAPACITY}    1
    Element Should Be Enabled    ${KNOP_SUBMIT}

TC-10 capacity onder 1 geeft fout
    [Tags]    regressie    negatief    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_CAPACITY}    0
    Klik Submit
    Pagina Bevat Fouttekst    capacity

TC-11 capacity niet numeriek geeft fout
    [Tags]    regressie    negatief    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_CAPACITY}    xyz
    Klik Submit
    Pagina Bevat Fouttekst    capacity

TC-12 campsite type is verplicht
    [Tags]    regressie    p0
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    campsite type

TC-13 terrain type is verplicht
    [Tags]    regressie    p0
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_TERRAIN_TYPE}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    terrain type

TC-14 accessibility level is verplicht
    [Tags]    regressie    p0
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    accessibility

TC-15 cross-field RV plus Difficult geeft fout
    [Tags]    regressie    business-rule    p1
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    rv
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    difficult
    Klik Submit
    Pagina Bevat Fouttekst    difficult

TC-16 cross-field Cabin plus Difficult geeft fout
    [Tags]    regressie    business-rule    p1
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    cabin
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    difficult
    Klik Submit
    Pagina Bevat Fouttekst    difficult

TC-17 cross-field capacity boven 20 zonder description geeft fout
    [Tags]    regressie    business-rule    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_CAPACITY}    21
    Input Text    ${VELD_DESCRIPTION}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    description

TC-18 cross-field price boven 500 en capacity lager dan 2 geeft fout
    [Tags]    regressie    business-rule    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_PRICE}    501
    Input Text    ${VELD_CAPACITY}    1
    Klik Submit
    Pagina Bevat Fouttekst    price

TC-19 cross-field glamping zonder amenities geeft fout
    [Tags]    regressie    business-rule    p1
    Vul Geldige Verplichte Velden
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    glamping
    Input Text    ${VELD_AMENITIES}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    amenities

TC-20 description, amenities en image url optioneel zonder rule violation
    [Tags]    regressie    p2
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc20
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Input Text    ${VELD_DESCRIPTION}    ${EMPTY}
    Input Text    ${VELD_AMENITIES}    ${EMPTY}
    Input Text    ${VELD_IMAGE_URL}    ${EMPTY}
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-21 image url is optioneel
    [Tags]    regressie    p2
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc21
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Input Text    ${VELD_IMAGE_URL}    ${EMPTY}
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-22 @smoke cancel navigeert terug zonder save
    [Tags]    smoke    regressie    p0
    Input Text    ${VELD_NAME}    Niet opslaan testplek
    Click Element    ${KNOP_CANCEL}
    Wacht Tot Lijst Pagina
    Page Should Not Contain    Niet opslaan testplek

TC-23 price grenswaarde exact 500 is toegestaan
    [Tags]    regressie    grenswaarde    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_PRICE}    500
    Input Text    ${VELD_CAPACITY}    4
    Element Should Be Enabled    ${KNOP_SUBMIT}

TC-24 capacity grenswaarde exact 20 is toegestaan
    [Tags]    regressie    grenswaarde    p1
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_CAPACITY}    20
    Input Text    ${VELD_DESCRIPTION}    Beschrijving aanwezig
    Element Should Be Enabled    ${KNOP_SUBMIT}

TC-25 price 501 met capacity exact 2 is toegestaan
    [Tags]    regressie    grenswaarde    p1
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc25
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Input Text    ${VELD_PRICE}    501
    Input Text    ${VELD_CAPACITY}    2
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-26 cross-field herstel: capacity boven 20 met description lost fout op
    [Tags]    regressie    business-rule    p1
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc26
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Input Text    ${VELD_CAPACITY}    21
    Input Text    ${VELD_DESCRIPTION}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    description
    Input Text    ${VELD_DESCRIPTION}    Grote groepslocatie met faciliteiten
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-27 cross-field herstel: glamping met amenities lost fout op
    [Tags]    regressie    business-rule    p1
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc27
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    glamping
    Input Text    ${VELD_AMENITIES}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    amenities
    Input Text    ${VELD_AMENITIES}    Fire pit, Hammock, Luxury tent
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-28 meerdere inline fouten tegelijk
    [Tags]    regressie    negatief    p2
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${EMPTY}
    Input Text    ${VELD_LOCATION}    ${EMPTY}
    Klik Submit
    Pagina Bevat Fouttekst    name
    Pagina Bevat Fouttekst    location

TC-29 cross-field fout verdwijnt na correctie van campsite type
    [Tags]    regressie    p2
    ${naam}=    Set Variable    Bosrand plek 14 cleanup tc29
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    backcountry
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    accessible
    Klik Submit
    Pagina Bevat Fouttekst    backcountry
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    tent
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    moderate
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}

TC-30 available for booking checkbox is aanwezig en klikbaar
    [Tags]    regressie    p2
    ${checkbox}=    Set Variable    xpath=//input[@name='available' and @type='checkbox']
    Element Should Be Visible    ${checkbox}
    ${staat_aan}=    Execute Javascript    return document.querySelector('input[name="available"]').checked;
    Log    Checkbox standaard staat: ${staat_aan}
    Click Element    ${checkbox}
    ${nieuw_staat}=    Execute Javascript    return document.querySelector('input[name="available"]').checked;
    Should Not Be Equal    '${staat_aan}'    '${nieuw_staat}'

TC-31 back to campsites link navigeert terug
    [Tags]    regressie    p2
    ${link}=    Set Variable    xpath=//a[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'back to campsites')]
    Element Should Be Visible    ${link}
    Click Element    ${link}
    Wacht Tot Lijst Pagina

TC-32 alleen spaties in name wordt geweigerd
    [Tags]    regressie    negatief    p2
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${SPACE}${SPACE}${SPACE}
    Klik Submit
    Pagina Bevat Fouttekst    name

TC-33 alleen spaties in location wordt geweigerd
    [Tags]    regressie    negatief    p2
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_LOCATION}    ${SPACE}${SPACE}${SPACE}
    Klik Submit
    Pagina Bevat Fouttekst    location

*** Keywords ***
Open Browser Naar Nieuw Formulier
    Open Browser    ${BASIS_URL}${PAD_NIEUW}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s

Ga Naar Nieuw Formulier
    Go To    ${BASIS_URL}${PAD_NIEUW}
    Wacht Tot Formulier Beschikbaar

Sluit Browser Veilig
    Run Keyword And Ignore Error    Close All Browsers

Cleanup Na Test
    ${naam}=    Set Variable    ${AANGEMAAKTE_CAMPSITE}
    IF    '${naam}' != ''
        Run Keyword And Ignore Error    Verwijder Campsite Uit Lijst    ${naam}
    END
    Set Suite Variable    ${AANGEMAAKTE_CAMPSITE}    ${EMPTY}

Registreer Aangemaakte Campsite
    [Arguments]    ${naam}
    Set Suite Variable    ${AANGEMAAKTE_CAMPSITE}    ${naam}

Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    Bosrand plek 14
    Input Text    ${VELD_LOCATION}    Veluwe
    Input Text    ${VELD_PRICE}    120
    Input Text    ${VELD_CAPACITY}    4
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    tent
    Select From List By Value    ${VELD_TERRAIN_TYPE}    forest
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    moderate

Klik Submit
    Click Button    ${KNOP_SUBMIT}

Wacht Tot Lijst Pagina
    Wait Until Location Contains    ${PAD_LIJST}    10s

Wacht Tot Formulier Beschikbaar
    ${submit_zichtbaar}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${KNOP_SUBMIT}    10s
    IF    not ${submit_zichtbaar}
        Wait Until Element Is Visible    ${VELD_NAME}    10s
    END

Verwijder Campsite Uit Lijst
    [Arguments]    ${naam}
    Go To    ${BASIS_URL}${PAD_LIJST}
    ${bestaat}=    Run Keyword And Return Status    Page Should Contain    ${naam}
    IF    ${bestaat}
        ${delete_in_rij}=    Set Variable    xpath=(//*[self::tr or self::li or self::div][contains(normalize-space(.),'${naam}')])[1]//button[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'delete') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'verwijder')]
        ${status}    ${_}=    Run Keyword And Ignore Error    Click Element    ${delete_in_rij}
        IF    '${status}' == 'FAIL'
            Run Keyword And Ignore Error    Click Button    xpath=(//button[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'delete') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'verwijder')])[1]
        END
        Run Keyword And Ignore Error    Click Button    xpath=//button[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'confirm') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'bevestig') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'ok')]
        Run Keyword And Ignore Error    Wait Until Page Does Not Contain    ${naam}    10s
    END

Pagina Bevat Fouttekst
    [Arguments]    ${deeltekst}
    ${locator}=    Set Variable    xpath=//*[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'${deeltekst}') and (contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'required') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'verplicht') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'invalid') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'must'))]
    Wait Until Element Is Visible    ${locator}    10s

Page Should Contain Any
    [Arguments]    @{opties}
    ${gevonden}=    Set Variable    ${FALSE}
    FOR    ${optie}    IN    @{opties}
        ${status}    ${_}=    Run Keyword And Ignore Error    Page Should Contain    ${optie}
        IF    '${status}' == 'PASS'
            ${gevonden}=    Set Variable    ${TRUE}
            Exit For Loop
        END
    END
    Should Be True    ${gevonden}
