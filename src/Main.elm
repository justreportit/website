module Main exposing (..)

import Browser
import Html exposing (Html, a, main_, div, footer, h1, h2, h3, h4, header, i, img, li, p, section, span, text, ul)
import Html.Attributes as Attr exposing (alt, href, src, target)
import Http
import Json.Decode exposing (Decoder, field, string)


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

-- MODEL

type alias Model =
    { thunderbirdVersion: String
    , outlookVersion: String
    }

type Msg
    = GotThunderbirdResp (Result Http.Error String)
    | GotOutlookResp (Result Http.Error String)

init: () -> (Model, Cmd Msg)
init _ =
    (Model "1.2.0" "0.1", Cmd.batch [ getThunderbirdVersion
                                    , getOutlookVersion
                                    ]
    )


-- UPDATE

githubBaseUrl: String
githubBaseUrl =
    "https://api.github.com/repos"


getThunderbirdVersion: Cmd Msg
getThunderbirdVersion =
    Http.get
        { url = githubBaseUrl ++ "/justreportit/thunderbird/releases/latest"
        , expect = Http.expectJson GotThunderbirdResp responseDecoder
        }

getOutlookVersion: Cmd Msg
getOutlookVersion =
    Http.get
        { url = githubBaseUrl ++ "/justreportit/outlook/releases/latest"
        , expect = Http.expectJson GotOutlookResp responseDecoder
        }

responseDecoder: Decoder String
responseDecoder =
    field "tag_name" string

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotThunderbirdResp res ->
            case res of
                Ok tag ->
                    ( { model | thunderbirdVersion = tag }, Cmd.none)
                Err _ ->
                    (model, Cmd.none)

        GotOutlookResp res ->
            case res of
                Ok tag ->
                    ( { model | outlookVersion = tag }, Cmd.none)
                Err _ ->
                    (model, Cmd.none)


-- VIEW

view: Model -> Html Msg
view model =
    div [ Attr.class "wrapped" ]
        [ viewHeader
        , main_ [] [ viewSectionMain model
                   , viewSectionAdvantages
                   ]
        , viewFooter
        ]


viewHeader: Html Msg
viewHeader =
    header [ Attr.class "header" ]
        [ div [ Attr.class "wrap" ]
            [ div [ Attr.class "flex" ]
                [ a [ Attr.class "logo", href "https://justreport.it/" ]
                    [ img [ alt "Just Report It", src "img/logo.svg" ]
                        []
                    ]
                , div [ Attr.class "action" ]
                    [ a [ Attr.class "btn js_user_agent_link", href "https://github.com/justreportit", target "_blank" ]
                        [ span [ Attr.class "text" ]
                            [ text "Source Code" ]
                        ]
                    ]
                ]
            ]
        ]

viewSectionAdvantages: Html Msg
viewSectionAdvantages =
    section
        [ Attr.class "section-advantages"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "flex list-advan"
                ]
                [ div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/github.svg"
                            , Attr.alt "github"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "Open-source" ]
                    , p []
                        [ i []
                            [ text "Just Report It " ]
                        , text "is a free and open-source, cross-platform addon to easily report spammers to the domain registrar." ]
                    ]
                , div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/sliders.svg"
                            , Attr.alt "sliders"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "Efficient, fast and scalable" ]
                    , p []
                        [ text "By utlizing ", a
                            [ Attr.href "https://aws.amazon.com/lambda/"
                            , Attr.target "_blank"
                            ]
                            [ text "serverless technologies" ]
                        , text ", we are able to quickly scale and adapt to any demand we may have and quickly fetch the registar's abuse information." ]
                    ]
                , div
                    [ Attr.class "item"
                    ]
                    [ div
                        [ Attr.class "img"
                        ]
                        [ img
                            [ Attr.src "img/thunderbird-black.svg"
                            , Attr.alt "firefox-black"
                            ]
                            []
                        ]
                    , h3 []
                        [ text "Multi-platform" ]
                    , p []
                        [ text "The addon is available for both Thunderbird and Outlook." ]
                    ]
                ]
            ]
        ]

viewSectionMain: Model -> Html Msg
viewSectionMain model =
    section
        [ Attr.class "section-main"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "block"
                ]
                [ div
                    [ Attr.class "title"
                    ]
                    [ h1 []
                        [ text "Just Report It - Free and open-source." ]
                    , h2 []
                        [ text "One-click to report to the registrar" ]
                    ]
                , div
                    [ Attr.class "action-btn flex"
                    ]
                    [ div
                        [ Attr.class "wrap-btn"
                        ]
                        [ a
                            [ Attr.href "https://addons.thunderbird.net/en-CA/thunderbird/addon/just-report-it/"
                            , Attr.class "btn js_user_agent_link"
                            , Attr.target "_blank"
                            ]
                            [ span
                                [ Attr.class "text"
                                ]
                                [ text "Thunderbird" ]
                            ]
                        , p
                            [ Attr.class "label"
                            , Attr.id "js_user_agent_version_date"
                            , Attr.attribute "data-text" "%version% - released %date% days ago"
                            ]
                            [ text ("Version " ++ model.thunderbirdVersion) ]
                        ]
                    , div
                        [ Attr.class "wrap-btn"
                        ]
                        [ a
                            [ Attr.href "https://github.com/justreportit/outlook/releases/download/0.1/0.1.zip"
                            , Attr.class "btn js_user_agent_link"
                            , Attr.target "_blank"
                            ]
                            [ span
                                [ Attr.class "text"
                                ]
                                [ text "Outlook" ]
                            ]
                        , p
                            [ Attr.class "label"
                            , Attr.id "js_user_agent_version_date"
                            , Attr.attribute "data-text" "%version% - released %date% days ago"
                            ]
                            [ text ("Version " ++ model.outlookVersion ++ " (Archived)") ]
                        ]
                    , div
                        [ Attr.class "wrap-btn"
                        ]
                        [ a
                            [ Attr.href "https://github.com/justreportit"
                            , Attr.class "btn white"
                            , Attr.target "_blank"
                            ]
                            [ span
                                [ Attr.class "alttext"
                                ]
                                [ text "Source Code" ]
                            ]
                        , p
                            [ Attr.class "label"
                            ]
                            [ text "Github (justreportit)" ]
                        ]
                    ]
                , div
                    [ Attr.class "description"
                    ]
                    [ p []
                        [ i []
                            [ text "Just Report It " ]
                        , text "is not a normal spam “reporter“, instead it focuses on the root of the problem and reports these domains straight to the registrar effectively blocking these spammers from ever sending spam from that email address again." ]
                    ]
                ]
            ]
        ]


viewFooter: Html Msg
viewFooter =
    footer
        [ Attr.class "footer"
        ]
        [ div
            [ Attr.class "wrap"
            ]
            [ div
                [ Attr.class "flex block-lists"
                ]
                [ div
                    [ Attr.class "item"
                    ]
                    [ a
                        [ Attr.href "https://justreport.it/"
                        , Attr.class "logo"
                        ]
                        [ img
                            [ Attr.src "img/logo.svg"
                            , Attr.alt "logo"
                            ]
                            []
                        ]
                    , div
                        [ Attr.class "item"
                        ]
                        [ h4
                            [ Attr.class "title-block"
                            ]
                            [ text "Platforms" ]
                        , ul []
                            [ li []
                                [ a
                                    [ Attr.href "https://addons.thunderbird.net/addon/just-report-it/"
                                    , Attr.target "_blank"
                                    ]
                                    [ text "Thunderbird" ]
                                ]
                            , li []
                                [ a
                                    [ Attr.href "https://github.com/justreportit/outlook/releases/download/0.1/0.1.zip"
                                    , Attr.target "_blank"
                                    ]
                                    [ text "Outlook" ]
                                ]
                            ]
                        ]
                    , div
                        [ Attr.class "item"
                        ]
                        [ h4
                            [ Attr.class "title-block"
                            ]
                            [ text "Resources" ]
                        , ul []
                            [ li []
                                [ a
                                    [ Attr.href "https://github.com/justreportit"
                                    , Attr.target "_blank"
                                    ]
                                    [ text "Source Code" ]
                                ]
                            ]
                        ]
                    ]
                , div
                    [ Attr.class "copyright"
                    ]
                    [ p []
                        [ text "Just Report It is developed by ", a
                            [ Attr.href "https://github.com/nicprov"
                            , Attr.target "_blank"
                            ]
                            [ text "Nicolas Provencher under GPL-3.0 License." ]
                        ]
                    ]
                , a
                    [ Attr.href "https://github.com/nicprov"
                    , Attr.target "_blank"
                    ]
                    []
                ]
            , a
                [ Attr.href "https://github.com/nicprov"
                , Attr.target "_blank"
                ]
                []
            ]
        ]