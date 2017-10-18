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
   
   <xsl:template name="divGen-main-content">
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
      <!-- toogle, ker sem spodaj dodal novo pretvorbo za persons -->
      <!-- seznam (indeks) oseb -->
      <!--<xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='persons']">
         <xsl:call-template name="persons"/>
      </xsl:if>-->
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
      <!-- DODAL SPODNJE SAMO ZA TO PRETVORBO! -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='datatable']">
         <xsl:call-template name="datatable"/>
      </xsl:if>
      <!-- za generiranje datateble posmrtnih mask (digitalnih objektov) -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='ius-esa']">
         <xsl:call-template name="ius-esa"/>
      </xsl:if>
      <!-- za generiranje datateble oseb -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='ius-as']">
         <xsl:call-template name="ius-as"/>
      </xsl:if>
      <!-- za generiranje seznama poklicev -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='ius-epa']">
         <xsl:call-template name="ius-epa"/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="datatable">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css" />
      <script type="text/javascript" src="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js"></script>
      
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="http://www2.sistory.si/publikacije/themes/js/plugin/DataTables/range-filter-external.js"></script>
      
      <link href="https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css" rel="stylesheet" type="text/css" />
      <link href="https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [0, 1, 2, 3, 4, 5, 6];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu izdaje</a>
            <div class="accordion-content rangeFilterWrapper" data-target="3" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu izdaje od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto izdaje (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto izdaje (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <table id="datatablePorocevalec" class="display responsive nowrap targetTable" data-order="[[ 4, &quot;asc&quot; ]]" width="100%" cellspacing="0">
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
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th></th>
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
   </xsl:template>
   
   <xsl:template name="ius-esa">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css" />
      <script type="text/javascript" src="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js"></script>
      
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="http://www2.sistory.si/publikacije/themes/js/plugin/DataTables/range-filter-external.js"></script>
      
      <link href="https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css" rel="stylesheet" type="text/css" />
      <link href="https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [2];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po datumu izdaje</a>
            <div class="accordion-content rangeFilterWrapper" data-target="1" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj od datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinYear" maxlength="4" placeholder="Leto"/>
                  </div>
               </div>
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">do datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxYear" maxlength="4" placeholder="Leto"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <div class="table-scroll">
         <table id="datatable-ESA" class="display targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Naslov</th>
                  <th>Datum</th>
                  <th>ESA</th>
                  <th>Povezava</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th></th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="//tei:idno[parent::tei:title][starts-with(normalize-space(.),'ESA')]">
                  <xsl:variable name="sistoryPDFpubID" select="substring-after(ancestor::tei:biblStruct[@xml:id]/@xml:id,'sistory.')"/>
                  <xsl:variable name="sistoryPDF" select="ancestor::tei:biblStruct[@xml:id]/tei:ref"/>
                  <xsl:variable name="page" select="ancestor::tei:biblStruct[1]/tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                  <xsl:variable name="sistoryPathToPDF">
                     <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1000,'/',$sistoryPDFpubID,'/')"/>
                  </xsl:variable>
                  <tr>
                     <td>
                        <xsl:apply-templates select="parent::tei:title"/>
                     </td>
                     <td data-search="{ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when}">
                        <xsl:attribute name="data-order">
                           <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                              <xsl:call-template name="sort-date"/>
                           </xsl:for-each>
                        </xsl:attribute>
                        <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                           <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                     </td>
                     <td>
                        <xsl:choose>
                           <xsl:when test="contains(normalize-space(.),'ESA ')">
                              <xsl:value-of select="substring-after(normalize-space(.),'ESA ')"/>
                           </xsl:when>
                           <xsl:when test="contains(.,'ESA-')">
                              <xsl:value-of select="substring-after(normalize-space(.),'ESA-')"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="normalize-space(.)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td>
                        <a href="{concat($sistoryPathToPDF,$sistoryPDF,'#page=',$page)}" title="Zgodovina Slovenije - SIstory" target="_blank">SIstory</a>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
            <br/>
            <br/>
            <br/>
         </table>
      </div>
   </xsl:template>
   
   <xsl:template name="ius-as">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css" />
      <script type="text/javascript" src="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js"></script>
      
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="http://www2.sistory.si/publikacije/themes/js/plugin/DataTables/range-filter-external.js"></script>
      
      <link href="https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css" rel="stylesheet" type="text/css" />
      <link href="https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [2];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po datumu izdaje</a>
            <div class="accordion-content rangeFilterWrapper" data-target="1" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj od datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinYear" maxlength="4" placeholder="Leto"/>
                  </div>
               </div>
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">do datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxYear" maxlength="4" placeholder="Leto"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <div class="table-scroll">
         <table id="datatable-AS" class="display targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Naslov</th>
                  <th>Datum</th>
                  <th>AS</th>
                  <th>Povezava</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th></th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="//tei:idno[parent::tei:title][starts-with(normalize-space(.),'AS')]">
                  <xsl:variable name="sistoryPDFpubID" select="substring-after(ancestor::tei:biblStruct[@xml:id]/@xml:id,'sistory.')"/>
                  <xsl:variable name="sistoryPDF" select="ancestor::tei:biblStruct[@xml:id]/tei:ref"/>
                  <xsl:variable name="page" select="ancestor::tei:biblStruct[1]/tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                  <xsl:variable name="sistoryPathToPDF">
                     <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1000,'/',$sistoryPDFpubID,'/')"/>
                  </xsl:variable>
                  <tr>
                     <td>
                        <xsl:apply-templates select="parent::tei:title"/>
                     </td>
                     <td data-search="{ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when}">
                        <xsl:attribute name="data-order">
                           <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                              <xsl:call-template name="sort-date"/>
                           </xsl:for-each>
                        </xsl:attribute>
                        <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                           <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                     </td>
                     <td>
                        <xsl:choose>
                           <xsl:when test="contains(normalize-space(.),'AS ')">
                              <xsl:value-of select="substring-after(normalize-space(.),'AS ')"/>
                           </xsl:when>
                           <xsl:when test="contains(.,'AS-')">
                              <xsl:value-of select="substring-after(normalize-space(.),'AS-')"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="normalize-space(.)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td>
                        <a href="{concat($sistoryPathToPDF,$sistoryPDF,'#page=',$page)}" title="Zgodovina Slovenije - SIstory" target="_blank">SIstory</a>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
            <br/>
            <br/>
            <br/>
         </table>
      </div>
   </xsl:template>
   
   <xsl:template name="ius-epa">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css" />
      <script type="text/javascript" src="https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js"></script>
      
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="http://www2.sistory.si/publikacije/themes/js/plugin/DataTables/range-filter-external.js"></script>
      
      <link href="https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css" rel="stylesheet" type="text/css" />
      <link href="https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [2, 3];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po datumu izdaje</a>
            <div class="accordion-content rangeFilterWrapper" data-target="1" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj od datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinYear" maxlength="4" placeholder="Leto"/>
                  </div>
               </div>
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">do datuma izdaje</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxDay" maxlength="2" placeholder="Dan"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxMonth" maxlength="2" placeholder="Mesec"/>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxYear" maxlength="4" placeholder="Leto"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <div class="table-scroll">
         <table id="datatable-EPA" class="display targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Naslov</th>
                  <th>Datum</th>
                  <th>EPA</th>
                  <th>Kratica</th>
                  <th>Povezava</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th></th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="//tei:idno[parent::tei:title][starts-with(normalize-space(.),'EPA')]">
                  <xsl:variable name="sistoryPDFpubID" select="substring-after(ancestor::tei:biblStruct[@xml:id]/@xml:id,'sistory.')"/>
                  <xsl:variable name="sistoryPDF" select="ancestor::tei:biblStruct[@xml:id]/tei:ref"/>
                  <xsl:variable name="page" select="ancestor::tei:biblStruct[1]/tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                  <xsl:variable name="sistoryPathToPDF">
                     <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($sistoryPDFpubID)) div 1000) * 1000) + 1000,'/',$sistoryPDFpubID,'/')"/>
                  </xsl:variable>
                  <tr>
                     <td>
                        <xsl:apply-templates select="parent::tei:title"/>
                     </td>
                     <td data-search="{ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when}">
                        <xsl:attribute name="data-order">
                           <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                              <xsl:call-template name="sort-date"/>
                           </xsl:for-each>
                        </xsl:attribute>
                        <xsl:for-each select="ancestor::tei:biblStruct/tei:monogr/tei:imprint/tei:date/@when">
                           <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                     </td>
                     <td>
                        <xsl:choose>
                           <xsl:when test="contains(normalize-space(.),'EPA ')">
                              <xsl:value-of select="substring-after(normalize-space(.),'EPA ')"/>
                           </xsl:when>
                           <xsl:when test="contains(.,'EPA-')">
                              <xsl:value-of select="substring-after(normalize-space(.),'EPA-')"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="normalize-space(.)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td>
                        <xsl:for-each select="normalize-space(preceding-sibling::tei:idno[1])">
                           <xsl:choose>
                              <xsl:when test="starts-with(.,'EPA')">
                                 <!-- ne procesiram -->
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="."/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </td>
                     <td>
                        <a href="{concat($sistoryPathToPDF,$sistoryPDF,'#page=',$page)}" title="Zgodovina Slovenije - SIstory" target="_blank">SIstory</a>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
            <br/>
            <br/>
            <br/>
         </table>
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
   
   <xsl:template name="format-date">
      <xsl:variable name="meseci">
         <mesec n="01">januar</mesec>
         <mesec n="02">februar</mesec>
         <mesec n="03">marec</mesec>
         <mesec n="04">april</mesec>
         <mesec n="05">maj</mesec>
         <mesec n="06">junij</mesec>
         <mesec n="07">julij</mesec>
         <mesec n="08">avgust</mesec>
         <mesec n="09">september</mesec>
         <mesec n="10">oktober</mesec>
         <mesec n="11">november</mesec>
         <mesec n="12">december</mesec>
      </xsl:variable>
      <xsl:choose>
         <!-- samo letnica -->
         <xsl:when test="not(contains(.,'-'))">
            <xsl:value-of select="."/>
         </xsl:when>
         <!-- celoten datum -->
         <xsl:when test="matches(.,'\d{4}-\d{2}-\d{2}')">
            <xsl:value-of select="format-date(.,'[D]. [M]. [Y]')"/>
         </xsl:when>
         <!-- drugače je samo mesec -->
         <xsl:otherwise>
            <xsl:variable name="month" select="tokenize(.,'-')[2]"/>
            <xsl:value-of select="concat($meseci/html:mesec[@n = $month],' ',tokenize(.,'-')[1])"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="sort-date">
      <xsl:choose>
         <!-- samo letnica -->
         <xsl:when test="not(contains(.,'-'))">
            <xsl:value-of select="concat(.,'0000')"/>
         </xsl:when>
         <!-- celoten datum -->
         <xsl:when test="matches(.,'\d{4}-\d{2}-\d{2}')">
            <xsl:value-of select="translate(.,'-','')"/>
         </xsl:when>
         <!-- drugače je samo mesec -->
         <xsl:otherwise>
            <xsl:value-of select="concat(translate(.,'-',''),'00')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Ker je pri body poglavjih samo eden div z vsebino, poenostavim prvotni template -->
   <xsl:template name="nav-body-head">Vsebina</xsl:template>
   
</xsl:stylesheet>
