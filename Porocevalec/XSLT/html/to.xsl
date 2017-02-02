<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="tei html teidocx xs"
   version="2.0">

   <xsl:import href="../../../../publikacije-XSLT/sistory/html5-foundation6-chs/to.xsl"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for making HTML5 output (Zurb Foundation 6 http://foundation.zurb.com/sites/docs/).</p>
         <p>This software is dual-licensed:
            
            1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
            Unported License http://creativecommons.org/licenses/by-sa/3.0/ 
            
            2. http://www.opensource.org/licenses/BSD-2-Clause
            
            
            
            Redistribution and use in source and binary forms, with or without
            modification, are permitted provided that the following conditions are
            met:
            
            * Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer.
            
            * Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.
            
            This software is provided by the copyright holders and contributors
            "as is" and any express or implied warranties, including, but not
            limited to, the implied warranties of merchantability and fitness for
            a particular purpose are disclaimed. In no event shall the copyright
            holder or contributors be liable for any direct, indirect, incidental,
            special, exemplary, or consequential damages (including, but not
            limited to, procurement of substitute goods or services; loss of use,
            data, or profits; or business interruption) however caused and on any
            theory of liability, whether in contract, strict liability, or tort
            (including negligence or otherwise) arising in any way out of the use
            of this software, even if advised of the possibility of such damage.
         </p>
         <p>Andrej Pančur, Institute for Contemporary History</p>
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>
   
   <!-- Uredi parametre v skladu z dodatnimi zahtevami za pretvorbo te publikacije: -->
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/to.xsl -->
   <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Porocevalec/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">true</xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description">Poročevalec Državnega zbora na portalu Zgodovina Slovenije - SIstory</xsl:param>
   <xsl:param name="keywords">Slovenija, Jugoslavija, parlament, skupščina, državni zbor, zakonodaja</xsl:param>
   <xsl:param name="title">Poročevalec Državnega zbora na portalu Zgodovina Slovenije - SIstory</xsl:param>
   
   
   <xsl:template match="tei:listBibl">
      <ol itemscope="" itemtype="https://schema.org/Periodical">
         <xsl:apply-templates mode="porocevalec">
            <xsl:sort select="tei:monogr/tei:imprint/tei:date/@when"/>
         </xsl:apply-templates>
      </ol>
   </xsl:template>
   
   <xsl:template match="tei:biblStruct" mode="porocevalec">
      <xsl:variable name="sistoryID" select="tei:monogr/tei:idno[@type='sistory']"/>
      <xsl:variable name="sistoryFile" select="tei:ref/@target"/>
      <li id="{@xml:id}">
         <!-- naslov serijske publikacije -->
         <em>
            <xsl:for-each select="tei:monogr/tei:title[@level='j'][1]">
               <xsl:value-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="tei:monogr/tei:title[@level='j'][2]">
               <xsl:text>: </xsl:text>
               <xsl:value-of select="."/>
            </xsl:for-each>
         </em>
         <xsl:text> </xsl:text>
         <!-- letnik -->
         <xsl:value-of select="concat(tei:monogr/tei:biblScope[@unit='volume'],' ')"/>
         <!-- številka -->
         <xsl:if test="tei:monogr/tei:biblScope[@unit='issue']">
            <xsl:variable name="issue" select="tei:monogr/tei:biblScope[@unit='issue']"/>
            <xsl:choose>
               <xsl:when test="matches($issue,'\d+')">
                  <xsl:value-of select="concat(', št. ',$issue,' ')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat(', ',$issue,' ')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
         <!-- datum izdaje -->
         <xsl:variable name="date" select="tei:monogr/tei:imprint/tei:date/@when"/>
         <xsl:variable name="year" select="tokenize($date,'-')[1]"/>
         <xsl:variable name="month" select="tokenize($date,'-')[2]"/>
         <xsl:variable name="day" select="tokenize($date,'-')[3]"/>
         <xsl:variable name="dateDisplay">
            <xsl:if test="string-length($day) gt 0">
               <xsl:value-of select="concat(number($day),'. ')"/>
            </xsl:if>
            <xsl:if test="string-length($month) gt 0">
               <xsl:value-of select="concat(number($month),'. ')"/>
            </xsl:if>
            <xsl:if test="string-length($year) gt 0">
               <xsl:value-of select="$year"/>
            </xsl:if>
         </xsl:variable>
         <xsl:value-of select="concat('(',$dateDisplay,')')"/>
         <!-- povezava na SIstory publikacijo -->
         <xsl:text> [</xsl:text>
         <a href="{concat('http://sistory.si/11686/',$sistoryID)}" title="Zgodovina Slovenije - SIstory" target="_blank">SIstory</a>
         <xsl:text>]</xsl:text>
         <!-- Vsebina: -->
         <xsl:if test="tei:relatedItem">
            <xsl:text>:</xsl:text>
            <ul>
               <xsl:for-each select="tei:relatedItem/tei:biblStruct">
                  <xsl:call-template name="PorocevalecContent">
                     <xsl:with-param name="sistoryID" select="$sistoryID"/>
                     <xsl:with-param name="sistoryFile" select="$sistoryFile"/>
                  </xsl:call-template>
               </xsl:for-each>
            </ul>
         </xsl:if>
      </li>
   </xsl:template>
   
   <xsl:template name="PorocevalecContent">
      <xsl:param name="sistoryID"/>
      <xsl:param name="sistoryFile"/>
      <xsl:variable name="sistoryPath" select="concat('/cdn/publikacije/',(xs:integer(round(number($sistoryID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($sistoryID)) div 1000) * 1000) + 1000,'/',$sistoryID,'/')"/>      
      <li>
         <xsl:value-of select="tei:analytic/tei:title[@level='a']"/>
         <xsl:text> [</xsl:text>
         <a href="{concat($sistoryPath,$sistoryFile,'#page=',tei:monogr/tei:imprint/tei:biblScope)}" title="Zgodovina Slovenije - SIstory" target="_blank">PDF</a>
         <xsl:text>]</xsl:text>
         <xsl:if test="tei:relatedItem">
            <xsl:text>:</xsl:text>
            <ul class="circle">
               <xsl:for-each select="tei:relatedItem/tei:biblStruct">
                  <xsl:call-template name="PorocevalecContent">
                     <xsl:with-param name="sistoryID" select="$sistoryID"/>
                     <xsl:with-param name="sistoryFile" select="$sistoryFile"/>
                  </xsl:call-template>
               </xsl:for-each>
            </ul>
         </xsl:if>
      </li>
   </xsl:template>
   
   <xsl:template name="datatable">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css"/>
      
      <script type="text/javascript" src="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js"></script>
      
      <xsl:text disable-output-escaping="yes"><![CDATA[<style>
         *, *::after, *::before {
    box-sizing: border-box;
}
.pagination .current {
    background: #8e130b;
}
      </style>

         ]]></xsl:text>
      
      <xsl:text disable-output-escaping="yes"><![CDATA[<script>
            $(document).ready(function() {
    $('#datatablePorocevalec').DataTable( {
        initComplete: function () {
            this.api().columns().every( function () {
                var column = this;
                var select = $('<select><option value=""></option></select>')
                    .appendTo( $(column.footer()).empty() )
                    .on( 'change', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );
 
                        column
                            .search( val ? '^'+val+'$' : '', true, false )
                            .draw();
                    } );
 
                column.data().unique().sort().each( function ( d, j ) {
                    select.append( '<option value="'+d+'">'+d+'</option>' )
                } );
            } );
        },
        "oLanguage": {
						"sProcessing": "Obdelujem...",
                            "sLengthMenu": "Prikaži _MENU_ zapisov",
                            "sZeroRecords": "Noben zapis ni bil najden",
                            "sInfo": "Prikazanih od _START_ do _END_ od skupno _TOTAL_ zapisov",
                            "sInfoEmpty": "Prikazanih od 0 do 0 od skupno 0 zapisov",
                            "sInfoFiltered": "(filtrirano po vseh _MAX_ zapisih)",
                            "sInfoPostFix": "",
                            "sSearch": "Išči po vseh stolpcih:",
                            "sUrl": "",
                            "oPaginate": {
                                "sFirst": "Prva",
                                "sPrevious": "Nazaj",
                                "sNext": "Naprej",
                                "sLast": "Zadnja"
                                }
					}
    } );
} );
        </script>]]></xsl:text>
      
      <div class="table-scroll">
         <table id="datatablePorocevalec" class="display" data-order="[[ 4, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Naslov</th>
                  <th>Letnik</th>
                  <th>Številka</th>
                  <th>Leto izdaje</th>
                  <th>Datum izdaje</th>
                  <th>Založnik</th>
                  <th>ISSN</th>
                  <th>Povezava</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th>Naslov</th>
                  <th>Letnik</th>
                  <th>Številka</th>
                  <th>Leto izdaje</th>
                  <th>Datum izdaje</th>
                  <th>Založnik</th>
                  <th>ISSN</th>
                  <th>Povezava</th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="ancestor::tei:TEI/tei:text/tei:body/tei:div[@type='listBibl']/tei:listBibl/tei:biblStruct">
                  <xsl:sort select="tei:monogr/tei:imprint/tei:date/@when"/>
                  <xsl:variable name="sistoryID" select="tei:monogr/tei:idno[@type='sistory']"/>
                  <tr>
                     <td>
                        <xsl:for-each select="tei:monogr/tei:title[@level='j']">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">: </xsl:if>
                        </xsl:for-each>
                     </td>
                     <td>
                        <xsl:value-of select="concat(tei:monogr/tei:biblScope[@unit='volume'],' ')"/>
                     </td>
                     <td>
                        <xsl:value-of select="tei:monogr/tei:biblScope[@unit='issue']"/>
                     </td>
                     <td>
                        <xsl:value-of select="tokenize(tei:monogr/tei:imprint/tei:date/@when,'-')[1]"/>
                     </td>
                     <!-- datum -->
                     <xsl:variable name="date" select="tei:monogr/tei:imprint/tei:date/@when"/>
                     <xsl:variable name="year" select="tokenize($date,'-')[1]"/>
                     <xsl:variable name="month" select="tokenize($date,'-')[2]"/>
                     <xsl:variable name="day" select="tokenize($date,'-')[3]"/>
                     <xsl:variable name="dateDisplay">
                        <xsl:if test="string-length($day) gt 0">
                           <xsl:value-of select="concat(number($day),'. ')"/>
                        </xsl:if>
                        <xsl:if test="string-length($month) gt 0">
                           <xsl:value-of select="concat(number($month),'. ')"/>
                        </xsl:if>
                        <xsl:if test="string-length($year) gt 0">
                           <xsl:value-of select="$year"/>
                        </xsl:if>
                     </xsl:variable>
                     <td data-order="{$date}">
                        <xsl:value-of select="$dateDisplay"/>
                     </td>
                     <td>
                        <xsl:for-each select="tei:monogr/tei:imprint/tei:publisher">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                     </td>
                     <td>
                        <xsl:value-of select="tei:monogr/tei:idno[@type='issn']"/>
                     </td>
                     <td data-order="{$sistoryID}">
                        <a href="{concat('http://sistory.si/11686/',$sistoryID)}" target="_blank">SIstory</a>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   
   <!-- dopolnim iskalnik, tako da procesira tudi //tei:div[@type='listBibl']/tei:listBibl/tei:biblStruct kot samostojne enote -->
   <xsl:template name="search">
      <xsl:variable name="tei-id" select="ancestor::tei:TEI/@xml:id"/>
      <xsl:variable name="sistoryAbsolutePath">
         <xsl:if test="$chapterAsSIstoryPublications='true'">http://www.sistory.si</xsl:if>
      </xsl:variable>
      <div class="tipue_search_content">
         <xsl:text> </xsl:text>
         <xsl:variable name="datoteka-js" select="concat($outputDir,ancestor::tei:TEI/@xml:id,'/','tipuesearch_content.js')"/>
         <xsl:result-document href="{$datoteka-js}" method="text" encoding="UTF-8">
            <!-- ZAČETEK JavaScript dokumenta -->
            <xsl:text>var tipuesearch = {"pages": [
                                    </xsl:text>
            
            <!-- procesira samo div[@type='listBibl]' -->
            <xsl:for-each select="//tei:div[@type='listBibl']/tei:listBibl/tei:biblStruct">
               <!--<xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>-->
               <xsl:variable name="generatedLink">
                  <xsl:apply-templates mode="generateLink" select="."/>
               </xsl:variable>
               <xsl:variable name="besedilo">
                  <xsl:apply-templates mode="besedilo"/>
               </xsl:variable>
               <xsl:text>{ "title": "</xsl:text>
               <xsl:value-of select="normalize-space(translate(translate(parent::tei:div/tei:head[1],'&#xA;',' '),'&quot;',''))"/>
               <!--<xsl:value-of select="normalize-space(translate(translate(ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/tei:head[1],'&#xA;',' '),'&quot;',''))"/>-->
               <xsl:text>", "text": "</xsl:text>
               <xsl:value-of select="normalize-space(translate($besedilo,'&#xA;&quot;','&#x20;'))"/>
               <xsl:text>", "tags": "</xsl:text>
               <xsl:text>", "loc": "</xsl:text>
               <xsl:value-of select="concat($sistoryAbsolutePath,$generatedLink)"/>
               <!--<xsl:value-of select="concat($ancestorChapter-id,'.html#',@xml:id)"/>-->
               <xsl:text>" }</xsl:text>
               <!--<xsl:if test="position() != last()">-->
                  <xsl:text>,</xsl:text>
               <!--</xsl:if>-->
               <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            
            <!-- vsa ostala vsebina : isto kot v originalnem search template -->
            <xsl:for-each select="//node()[ancestor::tei:TEI/@xml:id = $tei-id][@xml:id][ancestor::tei:text][parent::tei:div][not(self::tei:div)]">
               <!--<xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>-->
               <xsl:variable name="generatedLink">
                  <xsl:apply-templates mode="generateLink" select="."/>
               </xsl:variable>
               <xsl:variable name="besedilo">
                  <xsl:apply-templates mode="besedilo"/>
               </xsl:variable>
               <xsl:text>{ "title": "</xsl:text>
               <xsl:value-of select="normalize-space(translate(translate(parent::tei:div/tei:head[1],'&#xA;',' '),'&quot;',''))"/>
               <!--<xsl:value-of select="normalize-space(translate(translate(ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/tei:head[1],'&#xA;',' '),'&quot;',''))"/>-->
               <xsl:text>", "text": "</xsl:text>
               <xsl:value-of select="normalize-space(translate($besedilo,'&#xA;&quot;','&#x20;'))"/>
               <xsl:text>", "tags": "</xsl:text>
               <xsl:text>", "loc": "</xsl:text>
               <xsl:value-of select="concat($sistoryAbsolutePath,$generatedLink)"/>
               <!--<xsl:value-of select="concat($ancestorChapter-id,'.html#',@xml:id)"/>-->
               <xsl:text>" }</xsl:text>
               <xsl:if test="position() != last()">
                  <xsl:text>,</xsl:text>
               </xsl:if>
               <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            
            <!-- KONEC JavaScript dokumenta -->
            <xsl:text>
                     ]};
                </xsl:text>
         </xsl:result-document>
      </div>
      
      <!-- JavaScript, s katerim se požene iskanje -->
      <xsl:text disable-output-escaping="yes"><![CDATA[<script>
            $(document).ready(function() {
            $('.tipue_search_input').tipuesearch({
            'show': 10,
            'highlightEveryTerm': true,
            'descriptiveWords': 250});
            });
        </script>]]></xsl:text>
   </xsl:template>
   
   <!-- dodam divGen datatable -->
   <xsl:template match="tei:divGen">
      <xsl:variable name="datoteka" select="concat($outputDir,ancestor::tei:TEI/@xml:id,'/',@xml:id,'.html')"/>
      <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
         <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
         <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
         <html>
            <xsl:call-template name="addLangAtt"/>
            <!-- vključimo statični head -->
            <xsl:variable name="pagetitle">
               <xsl:choose>
                  <xsl:when test="tei:head">
                     <xsl:apply-templates select="tei:head" mode="plain"/>
                  </xsl:when>
                  <xsl:when test="self::tei:TEI">
                     <xsl:value-of select="tei:generateTitle(.)"/>
                  </xsl:when>
                  <xsl:when test="self::tei:text">
                     <xsl:value-of select="tei:generateTitle(ancestor::tei:TEI)"/>
                     <xsl:value-of select="concat('[', position(), ']')"/>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
            <!-- začetek body -->
            <body id="TOP">
               <xsl:call-template name="bodyMicroData"/>
               <xsl:call-template name="bodyJavascriptHook"/>
               <xsl:call-template name="bodyHook"/>
               <!-- začetek vsebine -->
               <div class="column row">
                  <xsl:if test="self::tei:divGen[@type='cip']">
                     <!-- Microdata - schema.org - dodam itemscope -->
                     <xsl:attribute name="itemscope"/>
                     <!-- in itemtype za knjige -->
                     <xsl:attribute name="itemtype">http://schema.org/Book</xsl:attribute>
                  </xsl:if>
                  <!-- vstavim svoj header -->
                  <xsl:call-template name="html-header">
                     <xsl:with-param name="thisChapter-id">
                        <xsl:value-of select="@xml:id"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <!-- GLAVNA VSEBINA -->
                  <section>
                     <div class="row">
                        <div class="medium-2 columns show-for-medium">
                           <xsl:call-template name="previous-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                           </xsl:call-template>
                        </div>
                        <div class="medium-8 small-12 columns">
                           <xsl:call-template name="stdheader">
                              <xsl:with-param name="title">
                                 <xsl:call-template name="header"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </div>
                        <div class="medium-2 columns show-for-medium text-right">
                           <xsl:call-template name="next-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                           </xsl:call-template>
                        </div>
                     </div>
                     <div class="row hide-for-medium">
                        <div class="small-6 columns text-center">
                           <xsl:call-template name="previous-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                           </xsl:call-template>
                        </div>
                        <div class="small-6 columns text-center">
                           <xsl:call-template name="next-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                           </xsl:call-template>
                        </div>
                     </div>
                     <!--<xsl:if test="$topNavigationPanel = 'true'">
                                                <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                                                    <xsl:call-template name="xrefpanel">
                                                         <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                                                         <xsl:with-param name="mode" select="local-name(.)"/>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:if>-->
                     <xsl:if test="$subTocDepth >= 0">
                        <xsl:call-template name="subtoc"/>
                     </xsl:if>
                     <xsl:call-template name="startHook"/>
                     <!-- VSTAVI VSEBINO divGen strani -->
                     <!-- kolofon CIP -->
                     <xsl:if test="self::tei:divGen[@type='cip']">
                        <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc" mode="kolofon"/>
                     </xsl:if>
                     <!-- TEI kolofon -->
                     <xsl:if test="self::tei:divGen[@type='teiHeader']">
                        <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
                     </xsl:if>
                     <!-- kazalo vsebine toc -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='toc'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='toc']">
                        <xsl:call-template name="mainTOC"/>
                     </xsl:if>
                     <!-- kazalo slik -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='images'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='images']">
                        <xsl:call-template name="images"/>
                     </xsl:if>
                     <!-- kazalo grafikonov -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='charts'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='charts']">
                        <xsl:call-template name="charts"/>
                     </xsl:if>
                     <!-- kazalo tabel -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='tables'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='tables']">
                        <xsl:call-template name="tables"/>
                     </xsl:if>
                     <!-- kazalo vsebine toc, ki izpiše samo glavne naslove poglavij, skupaj z imeni avtorjev poglavij -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleAuthor'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleAuthor']">
                        <xsl:call-template name="TOC-title-author"/>
                     </xsl:if>
                     <!-- kazalo vsebine toc, ki izpiše samo naslove poglavij, kjer ima div atributa type in xml:id -->
                     <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleType'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleType']">
                        <xsl:call-template name="TOC-title-type"/>
                     </xsl:if>
                     <!-- seznam (indeks) oseb -->
                     <xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='persons']">
                        <xsl:call-template name="persons"/>
                     </xsl:if>
                     <!-- seznam (indeks) krajev -->
                     <xsl:if test="self::tei:divGen[@type='index'][@xml:id='places'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='places']">
                        <xsl:call-template name="places"/>
                     </xsl:if>
                     <!-- seznam (indeks) organizacij -->
                     <xsl:if test="self::tei:divGen[@type='index'][@xml:id='organizations'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='organizations']">
                        <xsl:call-template name="organizations"/>
                     </xsl:if>
                     <!-- iskalnik -->
                     <xsl:if test="self::tei:divGen[@type='search']">
                        <xsl:call-template name="search"/>
                     </xsl:if>
                     <!-- SAMO TOLE SEM DODAL -->
                     <xsl:if test="self::tei:divGen[@type='datatable']">
                        <xsl:call-template name="datatable"/>
                     </xsl:if>
                     
                     <!--<xsl:call-template name="makeDivBody">
                                                <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                                            </xsl:call-template>-->
                     <xsl:call-template name="printNotes"/>
                     <!--<xsl:if test="$bottomNavigationPanel = 'true'">
                                                    <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                                                        <xsl:call-template name="xrefpanel">
                                                            <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                                                            <xsl:with-param name="mode" select="local-name(.)"/>
                                                        </xsl:call-template>
                                                     </xsl:element>
                                            </xsl:if>-->
                     <xsl:call-template name="stdfooter"/>
                  </section>
               </div>
               <xsl:call-template name="bodyEndHook"/>
            </body>
         </html>
      </xsl:result-document>
   </xsl:template>
   
   <!-- dodam divGen datatable -->
   <xsl:template name="title-bar-list-of-contents">
      <xsl:param name="thisChapter-id"/>
      <xsl:param name="title-bar-type"/>
      <xsl:variable name="sistoryParentPath">
         <xsl:choose>
            <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
               <xsl:variable name="teiParentId" select="self::tei:teiCorpus/@xml:id"/>
               <xsl:if test="$chapterAsSIstoryPublications='true'">
                  <xsl:call-template name="sistoryPath">
                     <xsl:with-param name="chapterID" select="$teiParentId"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
               <xsl:variable name="teiParentId" select="ancestor-or-self::tei:TEI/@xml:id"/>
               <xsl:if test="$chapterAsSIstoryPublications='true'">
                  <xsl:call-template name="sistoryPath">
                     <xsl:with-param name="chapterID" select="$teiParentId"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Poiščemo vse možne dele publikacije -->
      <!-- Naslovnica - index.html je vedno, kadar ni procesirano iz teiCorpus in ima hkrati TEI svoj xml:id -->
      <li>
         <xsl:if test="$thisChapter-id = 'index'">
            <xsl:attribute name="class">active</xsl:attribute>
         </xsl:if>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="ancestor::tei:teiCorpus and ancestor-or-self::tei:TEI[@xml:id]">
                     <xsl:value-of select="concat($sistoryParentPath,ancestor-or-self::tei:TEI/@xml:id,'.html')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat($sistoryParentPath,'index.html')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
               <xsl:when test="tei:text[@type = 'article'] or ancestor::tei:text[@type = 'article'] or self::tei:teiCorpus/tei:TEI/tei:text[@type = 'article']">
                  <xsl:sequence select="tei:i18n('Naslov')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:sequence select="tei:i18n('Naslovnica')"/>
               </xsl:otherwise>
            </xsl:choose>
         </a>
      </li>
      <!-- kolofon CIP -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']">
         <xsl:call-template name="header-cip">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- TEI kolofon -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']">
         <xsl:call-template name="header-teiHeader">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- kazalo toc -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']">
         <xsl:call-template name="header-toc">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- Uvodna poglavja v tei:front -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div">
         <xsl:call-template name="header-front">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- Osrednji del besedila v tei:body - Poglavja -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div">
         <xsl:call-template name="header-body">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- viri in literatura v tei:back -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
         <xsl:call-template name="header-bibliogr">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- Priloge v tei:back -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']">
         <xsl:call-template name="header-appendix">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- povzetki -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']">
         <xsl:call-template name="header-summary">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- Indeksi (oseb, krajev in organizacij) v divGen -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']">
         <xsl:call-template name="header-back-index">
            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
            <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
         </xsl:call-template>
      </xsl:if>
      <!-- DODANO za datatable -->
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='datatable']">
         <xsl:variable name="sistoryPath-datatable">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
               <xsl:call-template name="sistoryPath">
                  <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='datatable']/@xml:id"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:variable>
         <li>
            <xsl:if test=".[@type='datatable']">
               <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{concat($sistoryPath-datatable,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='datatable']/@xml:id,'.html')}">
               <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='datatable']/tei:head[1]"/>
            </a>
         </li>
      </xsl:if>
   </xsl:template>
   
   <!-- Ker je pri body poglavjih samo eden div z vsebino, poenostavim prvotni template -->
   <xsl:template name="nav-body-head">Vsebina</xsl:template>
   
</xsl:stylesheet>
