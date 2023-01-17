<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">

<link rel="stylesheet" href="/css/animate.min.css" />
<link rel="stylesheet" href="/css/app.css" />
<link rel="stylesheet" href="/css/spinner.css" />
</head>

<body>

   
<cfoutput>

    <!--- initialize LangEditor Component --->
    <cfset variables.LangEditorService=new components.LangEditorService()>
    <cfset variables.langData= LangEditorService.parseDataForTableOutput( LangEditorService.getFullWorkingData( ) )>
    <!--- sort keynames for output --->
    <cfset variables.adminKeyNameListOrdered=langData.keylist().listSort( "textnocase" )>
    <!--- get languages of resource files available in working folder --->
    <cfset variables.availableLangResourceLanguage=LangEditorService.getLanguagesAvailableInWorkingData()>
    <h1>
       Lucee Admin Language Editor #encodeForHTML(  variables.LangEditorService.version )#
    </h1>
    <cfif !arrayIsEmpty( availableLangResourceLanguage )>
        <div class="scrollUpButton" onClick="window.scrollTo({ top: 0 });">&##8679;</div>
    </cfif>
    <div class="commandDivWrapper">
        <cfset variables.availableJavaLocales=LangEditorService.getAvailableJavaLocalesAsStruct()>
               
        <div class="commandDiv">
            <select name="selectLangResource" id="selectLangResource">
                <cfset variables.langInLuceeSourceArray=LangEditorService.getAvailableLanguagesInLuceeGitSource()>
                <option value="">Select resource file</option>
                <cfloop array="#variables.langInLuceeSourceArray#" item="letterCode">
                    <option value="#encodeForHTMLAttribute( letterCode )#">#encodeForHTML( structKeyExists( availableJavaLocales, letterCode)?availableJavaLocales[ letterCode ]:letterCode )# (#encodeForHTML( letterCode )#.xml)</option>
                </cfloop>
            </select>
            <br>
            <button disabled class="button" onClick="var lang=$('##selectLangResource').val();if(lang==''){$('##selectLangResource').css({'border':'2px dotted red'})}else{ if( confirm( 'Warning: This will download and overwrite any existing \'' + lang + '.xml\' file in the working directory. Are you sure you want to proceed?'  ) ){ window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=cleanWorkingDirAndPullResources&lang='+ lang, 'GET', undefined, 'ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');}}">Pull From Lucee at github</button>
        </div>

        <div class="commandDiv">
            <select name="selectCreateLangResource" id="selectCreateLangResource">
                <option value="">Start from scratch</option>
                <cfloop collection="#variables.availableJavaLocales#" item="letterCode">
                    <cfif !langInLuceeSourceArray.contains( lettercode ) && !availableLangResourceLanguage.contains( lettercode ) >
                        <option value="#encodeForHTMLAttribute( letterCode )#">#encodeForHTML( structKeyExists( availableJavaLocales, letterCode)?availableJavaLocales[ letterCode ]:letterCode )# (#encodeForHTML( letterCode )#.xml)</option>
                    </cfif>
                </cfloop>
            </select>
            <br>
            <button disabled class="button" onClick="var lang=$('##selectCreateLangResource').val();if(lang==''){$('##selectCreateLangResource').css({'border':'2px dotted red'})}else{ if( confirm( 'Warning: This will create and overwrite any existing \'' + lang + '.xml\' file in the working directory. Are you sure you want to proceed?'  ) ){ window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=createUpdateWorkingLanguageResourceFile&lang='+ lang, 'GET', undefined, 'ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');}}">Initialize File</button>
        </div>

        <div class="commandDiv">
            <a class="button" href="/lucee/admin/server.cfm" target="_blank" style="margin-top:0;">Server Admin</a>
            <a class="button" href="/lucee/admin/web.cfm" target="_blank">Web Admin</a>
        </div>

        <cfif !arrayIsEmpty( availableLangResourceLanguage )>
            <div class="commandDiv lastPullRight">
                <button disabled class="button" onClick="if( confirm( 'Warning: This will remove all working files from the working directory and changes will be lost forever. Are you sure you want to proceed?' ) ){ window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=cleanWorkingDir', 'GET', undefined, 'ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');}">Reset and empty all</button>
            
            </div>
        </cfif>
        

        
    </div>

    <cfif !arrayIsEmpty( availableLangResourceLanguage )>
        <table class="langEditor">
            <thead>
                <tr>
                    <th>Property</th>
                    <cfloop array="#availableLangResourceLanguage#" item="itemLanguageKey" >
                        <th>#encodeForHTML( itemLanguageKey )#.xml <cfif itemLanguageKey == "en">(default)</cfif>
                                 <button disabled class="button enhanced" id="save_#encodeForHTMLAttribute( itemLanguageKey )#" onClick="window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=updateXmlWorkingFile&adminLang=#itemLanguageKey#', 'POST', '.updateContainer-#ucase(itemLanguageKey)# textarea', '##ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');">Save Changes to "#itemLanguageKey#.xml"<br> &amp; push to Admin </button>
                                <a class="button" href="#encodeForHTMLAttribute( "/workingDir/" & encodeforURL( itemLanguageKey ) & ".xml")#" target="_blank">View File XML-Source</a>
                                <!--- button disabled class="button" onClick="window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=pullToAdmin&lang=#encodeforURL( itemLanguageKey )#', 'GET', undefined, 'ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');">Push To Admin</button--->
                                <a class="button" href="#encodeForHTMLAttribute( "/ajaxApi/ajaxLangService.cfm?method=downloadFileXML&downloadLanguageXMLFile=" & encodeforURL( itemLanguageKey ) )#" target="_blank">Download File For PR</a>
                                <cfif itemLanguageKey !== "en">
                                    <button disabled class="button" onClick="if( confirm( 'Warning: This will remove the working file \'#encodeForHTMLAttribute( encodeForJavascript( LangEditorService.sanitizeFilename( itemLanguageKey ) & ".xml") )#\'. Are you sure you want to proceed?' ) ){ window.langUpdater.myAjaxUtils.buildPayLoad( '/ajaxApi/ajaxLangService.cfm?method=cleanWorkingDir&lang=#encodeForJavascript( encodeForURL( itemLanguageKey ) )#', 'GET', undefined, 'ajaxPopulateNotificationFlyingBar', 'reloadURLDelayed');}">Delete "#encodeForHTML( itemLanguageKey)#.xml"</button>
                                </cfif>
                        </th>
                    </cfloop>
                </tr>
            </thead>

            
            <tbody>
                <cfloop list="#adminKeyNameListOrdered#" item="itemLanguage" >
                    <tr id="#itemLanguage#">
                        <td class="keyName">
                            #encodeForHTML( itemLanguage )# 
                            <div class="propertyCommands">
                                <a  title="Search '#encodeForHTMLAttribute( itemLanguage)#' in Lucee Admin Source" class="propertyCommandsButton viewSourceButton" href="#variables.LangEditorService.getGithubSourceSearchURL( itemLanguage )#" target="_blank"></a>
                                <button title="Copy '#encodeForHTMLAttribute( itemLanguage)#' to Clipboard" class="propertyCommandsButton copyButton" href="#variables.LangEditorService.getGithubSourceSearchURL( itemLanguage )#" data-value="#encodeForHTMLAttribute( itemLanguage)#" onClick="window.langUpdater.copyToClipboard( $( this ).attr('data-value') );"></button>
                              
                            </div>
                        </td>
                        <cfloop array="#availableLangResourceLanguage#" item="itemLanguageKey" >
                            <td class="updateContainer-#ucase( itemLanguageKey )#">
                                <textarea <cfif trim( langData[ itemLanguage ][ itemLanguageKey ] ) is "">class="isempty"</cfif> name="#encodeForHTMLAttribute( replaceNoCase(itemLanguage, ".", "~", "All" ) )#">#encodeForHTML( langData[ itemLanguage ][ itemLanguageKey ] )#</textarea>
                            </td>
                        </cfloop>
                    </tr>
                </cfloop>
            </tbody>
            
        </table>
    </cfif>

    <span id="forkongithub">
        <a href="https://github.com/andreasRu/lucee-admin-language-editor" target="_blank">Fork me on GitHub</a>
    </span>
    <div id="ajaxPopulateNotificationFlyingBar" class="animated hidden">
        <div></div>
    </div>
    <div id="loadingSpinner">
        <div class="sk-chase">
            <div class="sk-chase-dot"></div>
            <div class="sk-chase-dot"></div>
            <div class="sk-chase-dot"></div>
            <div class="sk-chase-dot"></div>
            <div class="sk-chase-dot"></div>
            <div class="sk-chase-dot"></div>
        </div>
    </div>

    <script type="text/javascript" src="/js/jquery-3.6.3.min.js"></script>
    <script type="module" src="/js/langService.js"></script>
    <script type="text/javascript" src="/js/jquery.floatThead.min.js"></script>
    <script>
    /* call floatThead for fixed table head */ 
     $(function(){
            $('table').floatThead({
                position: 'fixed'
            });
        });


    /**  create a MutationObserver for ajaxPopulateNotificationFlyingbar: This is the flying Bar that
    *    is shown for a feedback 
    *    More Details https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver  
    **/
    /*  select the target node */
    var target = document.querySelector("##ajaxPopulateNotificationFlyingBar div");
    /* create an observer instance */
    var observer = new MutationObserver(function(mutations) {
        $( '##ajaxPopulateNotificationFlyingBar' ).removeClass( 'fadeOutLeft' ).removeClass( 'hidden' ).addClass( 'fadeInLeft' );
        setTimeout(function(){ 
            $( '##ajaxPopulateNotificationFlyingBar' ).removeClass( 'fadeInLeft' ).addClass( 'fadeOutLeft' ).addClass( 'hidden' );
            }, 5000);
    
    });
    /* configuration of the observer: */
    var config = { attributes: true, childList: true, characterData: true };
    /* pass in the target node, as well as the observer options */
    observer.observe(target, config);

    $('button').prop('disabled', false);
    </script>
</cfoutput>


</body></html>




