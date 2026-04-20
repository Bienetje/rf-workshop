*** Settings ***
Documentation       Aanvullende Robot Framework testcases voor Add New Campsite.
Library             SeleniumLibrary    timeout=10s    implicit_wait=0s
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
TC-A01 matrix submit blijft grijs
    [Tags]    aanvullend    negatief    matrix    p1
    [Template]    Verifieer Submit Blijft Grijs
    ${EMPTY}     Veluwe    120    4      tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      ${EMPTY}  120    4      tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    -1     4      tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    abc    4      tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    120    0      tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    120    xyz    tent          forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    120    4      ${EMPTY}      forest      moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    120    4      tent          ${EMPTY}    moderate    ${EMPTY}    ${EMPTY}           ${EMPTY}
    Bosrand      Veluwe    120    4      tent          forest      ${EMPTY}    ${EMPTY}    ${EMPTY}           ${EMPTY}

TC-A02 matrix verwacht succesvol opslaan
    [Tags]    aanvullend    regressie    matrix    p1
    [Template]    Verifieer Succesvol Opslaan
    an02a    Veluwe    120    4     tent       forest    moderate    ${EMPTY}               ${EMPTY}                 ${EMPTY}
    an02b    Veluwe    120    4     tent       forest    moderate    Korte beschrijving     Wifi, Douche            https://example.com/campsite-an02b.jpg
    an02c    Veluwe    501    2     tent       forest    moderate    ${EMPTY}               ${EMPTY}                 ${EMPTY}
    an02d    Veluwe    120    21    tent       forest    moderate    x                      ${EMPTY}                 ${EMPTY}
    an02e    Veluwe    120    4     glamping   forest    moderate    ${EMPTY}               Fire pit, Hammock       ${EMPTY}

TC-A03 cancel met geldig formulier slaat niet op
    [Tags]    aanvullend    regressie    p2
    ${naam}=    Set Variable    Bosrand extra an03
    Vul Geldige Verplichte Velden
    Input Text    ${VELD_NAME}    ${naam}
    Click Element    ${KNOP_CANCEL}
    Wacht Tot Lijst Pagina
    Page Should Not Contain    ${naam}

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
    Input Text    ${VELD_NAME}    Bosrand plek extra
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

Vul Formulierwaarden In
    [Arguments]    ${name}    ${location}    ${price}    ${capacity}    ${campsite_type}    ${terrain_type}    ${accessibility_level}    ${description}    ${amenities}    ${image_url}
    Input Text    ${VELD_NAME}    ${name}
    Input Text    ${VELD_LOCATION}    ${location}
    Input Text    ${VELD_PRICE}    ${price}
    Input Text    ${VELD_CAPACITY}    ${capacity}
    Select From List By Value    ${VELD_CAMPSITE_TYPE}    ${campsite_type}
    Select From List By Value    ${VELD_TERRAIN_TYPE}    ${terrain_type}
    Select From List By Value    ${VELD_ACCESSIBILITY_LEVEL}    ${accessibility_level}
    Input Text    ${VELD_DESCRIPTION}    ${description}
    Input Text    ${VELD_AMENITIES}    ${amenities}
    Input Text    ${VELD_IMAGE_URL}    ${image_url}

Verifieer Submit Blijft Grijs
    [Arguments]    ${name}    ${location}    ${price}    ${capacity}    ${campsite_type}    ${terrain_type}    ${accessibility_level}    ${description}    ${amenities}    ${image_url}
    Vul Formulierwaarden In    ${name}    ${location}    ${price}    ${capacity}    ${campsite_type}    ${terrain_type}    ${accessibility_level}    ${description}    ${amenities}    ${image_url}
    Element Should Be Disabled    ${KNOP_SUBMIT}

Verifieer Succesvol Opslaan
    [Arguments]    ${naam_suffix}    ${location}    ${price}    ${capacity}    ${campsite_type}    ${terrain_type}    ${accessibility_level}    ${description}    ${amenities}    ${image_url}
    ${naam}=    Set Variable    Bosrand extra ${naam_suffix}
    Vul Formulierwaarden In    ${naam}    ${location}    ${price}    ${capacity}    ${campsite_type}    ${terrain_type}    ${accessibility_level}    ${description}    ${amenities}    ${image_url}
    Element Should Be Enabled    ${KNOP_SUBMIT}
    Klik Submit
    Wacht Tot Lijst Pagina
    Registreer Aangemaakte Campsite    ${naam}
