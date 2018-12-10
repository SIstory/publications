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
   <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/ODZ/</xsl:param>
   
   <!-- odstranim pri spodnjih param true -->
   <xsl:param name="numberFigures"></xsl:param>
   <xsl:param name="numberFrontTables"></xsl:param>
   <xsl:param name="numberHeadings"></xsl:param>
   <xsl:param name="numberParagraphs"></xsl:param>
   <xsl:param name="numberTables"></xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description"></xsl:param>
   <xsl:param name="keywords"></xsl:param>
   <xsl:param name="title"></xsl:param>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc></xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="cssHook">
      <xsl:if test="$title-bar-sticky = 'true'">
         <xsl:value-of select="concat($path-general,'themes/css/foundation/6/sistory-sticky_title_bar.css')"/>
      </xsl:if>
      <link href="http://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'themes/plugin/TipueSearch/6.1/tipuesearch/css/normalize.css')}" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'themes/css/plugin/TipueSearch/6.1/my-tipuesearch.css')}"  rel="stylesheet" type="text/css" />
      <!-- dodam projektno specifičen css, ki se nahaja v istem direktoriju kot ostali HTML dokumenti -->
      <link href="project.css" rel="stylesheet" type="text/css"/>
   </xsl:template>
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>[html] Hook where extra Javascript functions can be defined</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="javascriptHook">
      <script src="{concat($path-general,'themes/foundation/6/js/vendor/jquery.js')}"></script>
      <!-- za highcharts -->
      <xsl:if test="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']]">
         <xsl:variable name="jsfile" select="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']][1]/tei:graphic[@mimeType = 'application/javascript']/@url"/>
         <xsl:variable name="chart-jsfile" select="document($jsfile)/html/body/script[1]/@src"/>
         <script src="{$chart-jsfile[1]}"></script>
      </xsl:if>
      <!-- za back-to-top in highcharts je drugače potrebno dati jquery, vendar sedaj ne rabim dodajati jquery kodo,
         ker je že vsebovana zgoraj -->
      <!-- dodan css jstree (mora biti za jquery.js -->
      <link href="{concat($path-general,'themes/plugin/jstree/3.3.5/dist/themes/default/style.min.css')}" rel="stylesheet" type="text/css" />
      <!-- dodan jstree -->
      <script src="{concat($path-general,'themes/plugin/jstree/3.3.5/dist/jstree.min.js')}"></script>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:pb">
      <!-- ne procesiram -->
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:app">
      <div>
         <xsl:if test="@xml:id">
            <xsl:attribute name="id">
               <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:lem">
      <div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:rdg">
      <div style="margin-left: 2.0em;">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:note[@type='comment']">
      <div style="margin-left: 2.0em;">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Odstranim prvotno procesiranje app elementov v opombah</desc>
   </doc>
   <xsl:template match="tei:app" mode="printnotes">
      <!--<xsl:variable name="identifier">
         <xsl:text>App</xsl:text>
         <xsl:choose>
            <xsl:when test="@xml:id">
               <xsl:value-of select="@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:number count="tei:app" level="any"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div class="app">
         <xsl:call-template name="makeAnchor">
            <xsl:with-param name="name" select="$identifier"/>
         </xsl:call-template>
         <span class="lemma">
            <xsl:call-template name="appLemma"/>
         </span>
         <xsl:text>] </xsl:text>
         <span class="lemmawitness">
            <xsl:call-template name="appLemmaWitness"/>
         </span>
         <xsl:call-template name="appReadings"/>
      </div>-->
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Namesto glavnega procesiranja kazala vsebine naredim treeview kazalo</desc>
   </doc>
   <xsl:template name="mainTOC">
      <div class="row" id="treeview-container">
         <ul>
            <xsl:for-each select="//tei:body/tei:div[@type][@xml:id]">
               <xsl:call-template name="TOC-title-type-li"/>
            </xsl:for-each>
         </ul>
         <script type="text/javascript">
            $('#treeview-container').jstree().bind("select_node.jstree", function (e, data) {
            var href = data.node.a_attr.href;
            document.location.href = href;
            });
         </script>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Popravim spodnji template: vključim app procesiranje</desc>
   </doc>
   <xsl:template name="TOC-title-type-li">
      <li>
         <a>
            <xsl:attribute name="href">
               <xsl:apply-templates mode="generateLink" select="."/>
            </xsl:attribute>
            <xsl:for-each select="tei:head">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text>: </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </a>
         <xsl:if test="tei:div[@type][@xml:id] or tei:app[@xml:id]">
            <ul>
               <xsl:for-each select="tei:div[@type][@xml:id] | tei:app[@xml:id]/tei:lem/tei:div[@type][@xml:id]">
                  <xsl:call-template name="TOC-title-type-li"/>
               </xsl:for-each>
            </ul>
         </xsl:if>
      </li>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>NASLOVNA STRAN</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template match="tei:titlePage">
      <!-- naslov -->
      <xsl:for-each select="tei:docTitle/tei:titlePart[1]">
         <h1 class="text-center">
            <xsl:apply-templates/>
         </h1>
         <xsl:for-each select="following-sibling::tei:titlePart">
            <h1 class="subheader podnaslov"><xsl:value-of select="."/></h1>
         </xsl:for-each>
      </xsl:for-each>
      <br/>
      <xsl:if test="tei:figure">
         <div class="text-center">
            <p>
               <img src="{tei:figure/tei:graphic/@url}" alt="naslovna slika"/>
            </p>
         </div>
      </xsl:if>
      <xsl:if test="tei:graphic">
         <div class="text-center">
            <p>
               <img src="{tei:graphic/@url}" alt="naslovna slika"/>
            </p>
         </div>
      </xsl:if>
      <br/>
      <p class="text-center">
         <xsl:apply-templates select="tei:byline[tei:docAuthor]" mode="titlePage"/>
      </p>
      <br/>
      <p class="text-center">
         <!-- založnik -->
         <xsl:for-each select="tei:docImprint/tei:publisher">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
         <!-- kraj izdaje -->
         <xsl:for-each select="tei:docImprint/tei:pubPlace">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
         <!-- leto izdaje -->
         <xsl:for-each select="tei:docImprint/tei:docDate">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
      </p>
      <br/>
      <p class="text-center">
         <xsl:apply-templates select="tei:byline[not(tei:docAuthor)]" mode="titlePage"/>
      </p>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:byline" mode="titlePage">
      <xsl:apply-templates mode="titlePage"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:docAuthor" mode="titlePage">
      <xsl:apply-templates mode="titlePage"/>
   </xsl:template>
   
</xsl:stylesheet>
