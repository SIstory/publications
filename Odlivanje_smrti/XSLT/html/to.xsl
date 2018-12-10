<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:lido="http://www.lido-schema.org"
   exclude-result-prefixes="tei html teidocx xs lido"
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
   <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Odlivanje_smrti/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">true</xsl:param>
   
   <!-- TODO: NE VEM zakaj v tem to.xsl ni deloval template name sistoryID za spodaj dodane povezave.
        Mogoče problem z lido namespace?
        Ker ima celotna HTML publikacija na SIstory samo sistory ID, sem tega zato začasno dodal v spodnji parameter.
   -->
   <xsl:param name="SISTORYID">37475</xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description">Odlivanje smrti. Pregled objav na portalu Zgodovina Slovenije - SIstory</xsl:param>
   <xsl:param name="keywords">posmrtne maske, Slovenija</xsl:param>
   <xsl:param name="title">Odlivanje smrti</xsl:param>
   
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc> LIDO metadata </xsldoc:desc>
   </xsldoc:doc>
   <xsl:template match="tei:ptr[@type='LIDO']">
      <xsl:variable name="sistoryID" select="substring-after(ancestor::tei:list[@type='gloss']/parent::tei:item/@xml:id,'sistory-')"/>
      <xsl:variable name="path2mask" select="concat('/cdn/publikacije/37001-38000/37475/mask.html?id=',$sistoryID)"/>
      <a href="{$path2mask}" target="_blank">Vsi metapodatki</a>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="divGen-process-content">
      <xsl:if test="self::tei:divGen[@xml:id='mask']">
         <script type="text/javascript" src="SaxonJS.min.js"></script>
         <xsl:text disable-output-escaping="yes"><![CDATA[<script>
            window.onload = function() {
            SaxonJS.transform({
            stylesheetLocation: "mask.sef",
            sourceLocation: "Odlivanje_smrti.xml"
            });
            }     
         </script>]]></xsl:text>
         
         <div id="maska"/>
         
      </xsl:if>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template match="tei:listPerson[@xml:id = 'persons-deathMask']">
      <xsl:variable name="maske">
         <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type='lido']/tei:list[@type='deathMask']/tei:item[@xml:id]">
            <xsl:variable name="position" select="position()"/>
            <xsl:variable name="maskID" select="@xml:id"/>
            <xsl:for-each select="tei:list/tei:item[tei:ref]">
               <tei:maska position="{$position}" chapterID="{ancestor::tei:div[@type='lido']/@xml:id}" maskID="{$maskID}" personID="{substring-after(tei:ref/@target,'#')}" label="{preceding-sibling::tei:label[1]}">
                  <xsl:value-of select="$position"/>
               </tei:maska>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:variable>
      <ol>
         <xsl:for-each select="tei:person">
            <xsl:variable name="personID" select="@xml:id"/>
            <xsl:variable name="spol" select="tei:sex/@value"/>
            <li id="{@xml:id}">
               <!-- Priimek, Ime (samo prva enačica zapisa) -->
               <xsl:for-each select="tei:persName[1]">
                  <xsl:choose>
                     <xsl:when test="not(child::*)">
                        <xsl:value-of select="."/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="tei:surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="tei:forename"/>
                        <xsl:if test="tei:addName">
                           <xsl:value-of select="concat(' - ',tei:addName)"/>
                        </xsl:if>
                        <xsl:if test="tei:genName">
                           <xsl:value-of select="concat(' ',tei:genName)"/>
                        </xsl:if>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <!-- v oklepaju letnici rojstva in smrti -->
               <xsl:if test="tei:birth/tei:date or tei:death/tei:date">
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="tokenize(tei:birth/tei:date/@when,'-')[1]"/>
                  <xsl:if test="tei:death/tei:date">–</xsl:if>
                  <xsl:value-of select="tokenize(tei:death/tei:date/@when,'-')[1]"/>
                  <xsl:text>)</xsl:text>
               </xsl:if>
               <!-- ostali podatki -->
               <ul>
                  <xsl:if test="tei:birth">
                     <li>
                        <xsl:text>Rojstvo: </xsl:text>
                        <xsl:choose>
                           <xsl:when test="contains(tei:birth/tei:date/@when,'-')">
                              <xsl:value-of select="format-date(tei:birth/tei:date/@when,'[D]. [M]. [Y]','en',(),())"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="tei:birth/tei:date/@when"/>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="tei:birth/tei:placeName">
                           <xsl:text> (</xsl:text>
                           <xsl:for-each select="tei:birth/tei:placeName[1]/*[not(self::tei:geo)]">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                           </xsl:for-each>
                           <xsl:text>)</xsl:text>
                        </xsl:if>
                     </li>
                  </xsl:if>
                  <xsl:if test="tei:death">
                     <li>
                        <xsl:text>Smrt: </xsl:text>
                        <xsl:choose>
                           <xsl:when test="contains(tei:death/tei:date/@when,'-')">
                              <xsl:value-of select="format-date(tei:death/tei:date/@when,'[D]. [M]. [Y]','en',(),())"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="tei:death/tei:date/@when"/>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="tei:death/tei:placeName">
                           <xsl:text> (</xsl:text>
                           <xsl:for-each select="tei:death/tei:placeName[1]/*[not(self::tei:geo)]">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                           </xsl:for-each>
                           <xsl:text>)</xsl:text>
                        </xsl:if>
                     </li>
                  </xsl:if>
                  <xsl:for-each-group select="$maske/tei:maska[@personID = $personID]" group-by="@label">
                     <li>
                        <xsl:if test="current-grouping-key() = 'Avtor'">
                           <xsl:if test="$spol = 'M'">Avtor posmrtne maske </xsl:if>
                           <xsl:if test="$spol = 'F'">Avtorica posmrtne maske </xsl:if>
                        </xsl:if>
                        <xsl:if test="current-grouping-key() = 'Upodobljenec'">
                           <xsl:if test="$spol = 'M'">Upodobljen na posmrtni maski </xsl:if>
                           <xsl:if test="$spol = 'F'">Upodobljena na posmrtni maski </xsl:if>
                        </xsl:if>
                        <xsl:for-each select="current-group()">
                           <a>
                              <xsl:attribute name="href">
                                 <!-- dodana relativna pot v okviru SIstory -->
                                 <xsl:variable name="sistoryPath">
                                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                                       <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                       <!--<xsl:call-template name="sistoryPath">
                                          <xsl:with-param name="chapterID" select="@chapterID"/>
                                       </xsl:call-template>-->
                                    </xsl:if>
                                 </xsl:variable>
                                 <xsl:sequence select="concat($sistoryPath,@chapterID,$standardSuffix,'#',@maskID)"/>
                              </xsl:attribute>
                              <xsl:value-of select="concat('št. ',@position)"/>
                           </a>
                           <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                        <xsl:text> (skupaj: </xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                        <xsl:text>)</xsl:text>
                     </li>
                  </xsl:for-each-group>
                  <xsl:if test="tei:occupation">
                     <li>
                        <xsl:text>Poklici/i in dejavnost/i: </xsl:text>
                        <xsl:for-each select="tei:occupation">
                           <xsl:variable name="occupationCode" select="substring-after(@code,'#')"/>
                           <xsl:for-each select="//tei:category[@xml:id = $occupationCode]">
                              <xsl:variable name="categoryPosition">
                                 <xsl:number count="tei:category" level="any"/>
                              </xsl:variable>
                              <xsl:variable name="chapterID" select="ancestor::tei:TEI/tei:text/tei:back/tei:divGen[@xml:id = 'occupations']/@xml:id"/>
                              <a>
                                 <xsl:attribute name="href">
                                    <!-- dodana relativna pot v okviru SIstory -->
                                    <xsl:variable name="sistoryPath">
                                       <xsl:if test="$chapterAsSIstoryPublications='true'">
                                          <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                          <!--<xsl:call-template name="sistoryPath">
                                             <xsl:with-param name="chapterID" select="@chapterID"/>
                                          </xsl:call-template>-->
                                       </xsl:if>
                                    </xsl:variable>
                                    <xsl:sequence select="concat($sistoryPath,$chapterID,$standardSuffix,'#', concat('category-',$categoryPosition))"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="tei:desc[1]"/>
                              </a>
                           </xsl:for-each>
                           <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
                  <xsl:if test="tei:idno[@type='URL']">
                     <li>
                        <xsl:text>Dodatni podatki: </xsl:text>
                        <xsl:for-each select="tei:idno[@type='URL']">
                           <a href="{.}" target="_blank">
                              <xsl:value-of select="."/>
                           </a>
                           <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
               </ul>
            </li>
         </xsl:for-each>
      </ol>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="thisLanguage"></xsldoc:param>
   </xsldoc:doc>
   <xsl:template name="divGen-main-content">
      <xsl:param name="thisLanguage"/>
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
      <!-- prazen divGen, v katerem lahko naknadno poljubno procesiramo vsebino -->
      <xsl:if test="self::tei:divGen[@type='content']">
         <xsl:call-template name="divGen-process-content"/>
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
      <!-- za generiranje datateble posmrtnih mask (digitalnih objektov) -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='objects']">
         <xsl:call-template name="datatables-masks"/>
      </xsl:if>
      <!-- za generiranje datateble oseb -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons']">
         <xsl:call-template name="datatables-persons"/>
      </xsl:if>
      <!-- za generiranje datateble mask z znanimi upodobljenci -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='representation']">
         <xsl:call-template name="datatables-representation"/>
      </xsl:if>
      <!-- za generiranje datateble upodobljencev posmrtnih mask -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='representation-persons']">
         <xsl:call-template name="datatables-representation-persons"/>
      </xsl:if>
      <!-- za generiranje seznama poklicev -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='occupations']">
         <xsl:call-template name="occupations"/>
      </xsl:if>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="occupations">
      <xsl:variable name="poklici">
         <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type='listPerson']/tei:listPerson/tei:person">
            <xsl:variable name="chapterID" select="ancestor::tei:div[@type='listPerson']/@xml:id"/>
            <xsl:variable name="personID" select="@xml:id"/>
            <xsl:variable name="positionPerson" select="position()"/>
            <xsl:for-each select="tei:occupation">
               <tei:poklic chapterID="{$chapterID}" personID="{$personID}" positionPerson="{$positionPerson}" occupationID="{substring-after(@code,'#')}"/>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:variable>
      <ul>
         <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy">
            <xsl:for-each select="tei:category">
               <xsl:variable name="categoryPosition">
                  <xsl:number count="tei:category" level="any"/>
               </xsl:variable>
               <xsl:call-template name="occupations-list">
                  <xsl:with-param name="poklici" select="$poklici"/>
                  <xsl:with-param name="categoryPosition" select="$categoryPosition"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:for-each>
      </ul>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="poklici"/>
      <xsldoc:param name="categoryPosition"/>
   </xsldoc:doc>
   <xsl:template name="occupations-list">
      <xsl:param name="poklici"/>
      <xsl:param name="categoryPosition"/>
      <xsl:if test="descendant-or-self::tei:category[@xml:id = $poklici/tei:poklic/@occupationID]">
         <li id="{concat('category-',$categoryPosition)}">
            <xsl:value-of select="tei:desc[1]"/>
            <xsl:if test="tei:category">
               <ul>
                  <xsl:for-each select="tei:category">
                     <xsl:variable name="categoryPosition-2">
                        <xsl:number count="tei:category" level="any"/>
                     </xsl:variable>
                     <xsl:call-template name="occupations-list">
                        <xsl:with-param name="poklici" select="$poklici"/>
                        <xsl:with-param name="categoryPosition" select="$categoryPosition-2"/>
                     </xsl:call-template>
                  </xsl:for-each>
               </ul>
            </xsl:if>
            <!-- izpis povezav na morebitne osebe s tem poklicem -->
            <xsl:call-template name="occupation-persons">
               <xsl:with-param name="poklici" select="$poklici"/>
               <xsl:with-param name="occupationID" select="@xml:id"/>
            </xsl:call-template>
         </li>
      </xsl:if>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
      <xsldoc:param name="poklici"/>
      <xsldoc:param name="occupationID"/>
   </xsldoc:doc>
   <xsl:template name="occupation-persons">
      <xsl:param name="poklici"/>
      <xsl:param name="occupationID"/>
      <xsl:for-each-group select="$poklici/tei:poklic" group-by="@occupationID">
         <xsl:if test="current-grouping-key() = $occupationID">
            <xsl:text> [Oseba </xsl:text>
            <xsl:for-each select="current-group()">
               <a>
                  <xsl:attribute name="href">
                     <!-- dodana relativna pot v okviru SIstory -->
                     <xsl:variable name="sistoryPath">
                        <xsl:if test="$chapterAsSIstoryPublications='true'">
                           <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                           <!--<xsl:call-template name="sistoryPath">
                              <xsl:with-param name="chapterID" select="@chapterID"/>
                           </xsl:call-template>-->
                        </xsl:if>
                     </xsl:variable>
                     <xsl:sequence select="concat($sistoryPath,@chapterID,$standardSuffix,'#',@personID)"/>
                  </xsl:attribute>
                  <xsl:value-of select="concat('št. ',@positionPerson)"/>
               </a>
               <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>, skupaj: </xsl:text>
            <xsl:value-of select="count(current-group())"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each-group>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="datatables-masks">
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
         var columnIDs = [2, 3, 4];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu nastanka maske</a>
            <div class="accordion-content rangeFilterWrapper" data-target="2" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu nastanka od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto nastanka (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto nastanka (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <table id="datatableMasks" class="display responsive nowrap targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
         <thead>
            <tr>
               <th>Zaporedje</th>
               <th>Naziv</th>
               <th>Leto</th>
               <th>Upodobljenec</th>
               <th>Ustanova</th>
            </tr>
         </thead>
         <tfoot>
            <tr>
               <th></th>
               <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
            </tr>
         </tfoot>
         <tbody>
            <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type='lido']/tei:list[@type='deathMask']/tei:item">
               <xsl:variable name="maskID" select="@xml:id"/>
               <xsl:variable name="sistoryID" select="substring-after(@xml:id,'sistory-')"/>
               <xsl:variable name="path2lido" select="concat('../../LIDO/',$sistoryID,'/metadata.xml')"/>
               <tr>
                  <!-- Zaporedje -->
                  <td data-order="{position()}">
                     <xsl:variable name="chapterID" select="ancestor::tei:div[@type ='lido']/@xml:id"/>
                     <a>
                        <xsl:attribute name="href">
                           <!-- dodana relativna pot v okviru SIstory -->
                           <xsl:variable name="sistoryPath">
                              <xsl:if test="$chapterAsSIstoryPublications='true'">
                                 <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                 <!--<xsl:call-template name="sistoryPath">
                                       <xsl:with-param name="chapterID" select="@chapterID"/>
                                    </xsl:call-template>-->
                              </xsl:if>
                           </xsl:variable>
                           <xsl:sequence select="concat($sistoryPath,$chapterID,$standardSuffix,'#',$maskID)"/>
                        </xsl:attribute>
                        <xsl:value-of select="position()"/>
                     </a>
                  </td>
                  <!-- Naziv -->
                  <td>
                     <xsl:value-of select="tei:list/tei:item[1]"/>
                  </td>
                  <!-- Leto -->
                  <td>
                     <xsl:value-of select="document($path2lido)/lido:lidoWrap/lido:lido/lido:descriptiveMetadata/lido:eventWrap/lido:eventSet/lido:event/lido:eventDate/lido:date/lido:earliestDate"/>
                  </td>
                  <!-- Upodobljenec -->
                  <td>
                     <xsl:value-of select="document($path2lido)/lido:lidoWrap/lido:lido/lido:descriptiveMetadata/lido:objectClassificationWrap/lido:classificationWrap/lido:classification/lido:term"/>
                  </td>
                  <!-- Ustanova -->
                  <td>
                     <xsl:value-of select="document($path2lido)/lido:lidoWrap/lido:lido/lido:descriptiveMetadata/lido:objectIdentificationWrap/lido:repositoryWrap/lido:repositorySet/lido:repositoryName/lido:legalBodyName/lido:appellationValue"/>
                  </td>
               </tr>
            </xsl:for-each>
         </tbody>
      </table>
      <br/>
      <br/>
      <br/>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="datatables-persons">
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
         var columnIDs = [4, 5, 6, 7, 8];
      </script>
      
      <div>
         <ul class="accordion" data-accordion="" data-allow-all-closed="true">
            <li class="accordion-item" data-accordion-item="">
               <a href="#" class="accordion-title">Filtriraj po datumu rojstva</a>
               <div class="accordion-content rangeFilterWrapper" data-target="2" data-tab-content="">
                  <div class="row">
                     <div class="small-3 columns">
                        <label for="middle-label" class="text-right middle">Filtriraj od datuma rojstva</label>
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
                        <label for="middle-label" class="text-right middle">do datuma rojstva</label>
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
            <li class="accordion-item" data-accordion-item="">
               <a href="#" class="accordion-title">Filtriraj po datumu smrti</a>
               <div class="accordion-content rangeFilterWrapper" data-target="3" data-tab-content="">
                  <div class="row">
                     <div class="small-3 columns">
                        <label for="middle-label" class="text-right middle">Filtriraj od datuma smrti</label>
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
                        <label for="middle-label" class="text-right middle">do datuma smrti</label>
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
         
         <table id="datatablePersons" class="display responsive nowrap targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Zaporedje</th>
                  <th>Priimek in ime</th>
                  <th>Datum rojstva</th>
                  <th>Datum smrti</th>
                  <th>Spol</th>
                  <th>Avtor maske</th>
                  <th>Upodobljenec</th>
                  <th>Poklic 1</th>
                  <th>Poklic 2</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><input class="filterInputText" placeholder="LLLL-MM-DD" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type ='listPerson']/tei:listPerson/tei:person">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:variable name="vloge">
                     <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type='lido']/tei:list[@type='deathMask']/tei:item[@xml:id]/tei:list/tei:item[substring-after(tei:ref/@target,'#') = $personID]">
                        <tei:vloga>
                           <xsl:value-of select="preceding-sibling::tei:label[1]"/>
                        </tei:vloga>
                     </xsl:for-each>
                  </xsl:variable>
                  <tr>
                     <!-- Zaporedje -->
                     <td data-order="{position()}">
                        <xsl:variable name="chapterID" select="ancestor::tei:div[@type ='listPerson']/@xml:id"/>
                        <a>
                           <xsl:attribute name="href">
                              <!-- dodana relativna pot v okviru SIstory -->
                              <xsl:variable name="sistoryPath">
                                 <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                    <!--<xsl:call-template name="sistoryPath">
                                       <xsl:with-param name="chapterID" select="@chapterID"/>
                                    </xsl:call-template>-->
                                 </xsl:if>
                              </xsl:variable>
                              <xsl:sequence select="concat($sistoryPath,$chapterID,$standardSuffix,'#',$personID)"/>
                           </xsl:attribute>
                           <xsl:value-of select="position()"/>
                        </a>
                     </td>
                     <!-- Priimek in ime -->
                     <td>
                        <xsl:for-each select="tei:persName[1]">
                           <xsl:choose>
                              <xsl:when test="not(child::*)">
                                 <xsl:value-of select="."/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="tei:surname"/>
                                 <xsl:text>, </xsl:text>
                                 <xsl:value-of select="tei:forename"/>
                                 <xsl:if test="tei:addName">
                                    <xsl:value-of select="concat(' - ',tei:addName)"/>
                                 </xsl:if>
                                 <xsl:if test="tei:genName">
                                    <xsl:value-of select="concat(' ',tei:genName)"/>
                                 </xsl:if>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </td>
                     <!-- datum rojstva -->
                     <td data-search="{tei:birth/tei:date/@when}">
                        <xsl:attribute name="data-order">
                           <xsl:for-each select="tei:birth/tei:date/@when">
                              <xsl:call-template name="sort-date"/>
                           </xsl:for-each>
                        </xsl:attribute>
                        <xsl:for-each select="tei:birth/tei:date/@when">
                           <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                     </td>
                     <!-- datum smrti -->
                     <td data-search="{tei:death/tei:date/@when}">
                        <xsl:attribute name="data-order">
                           <xsl:for-each select="tei:death/tei:date/@when">
                              <xsl:call-template name="sort-date"/>
                           </xsl:for-each>
                        </xsl:attribute>
                        <xsl:for-each select="tei:death/tei:date/@when">
                           <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                     </td>
                     <!-- spol -->
                     <td>
                        <xsl:if test="tei:sex/@value = 'M'">Moški</xsl:if>
                        <xsl:if test="tei:sex/@value = 'F'">Ženska</xsl:if>
                     </td>
                     <!-- avtor maske -->
                     <td>
                        <xsl:choose>
                           <xsl:when test="$vloge/tei:vloga[. = 'Avtor']">Da</xsl:when>
                           <xsl:otherwise>Ne</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <!-- upodobljenec -->
                     <td>
                        <xsl:choose>
                           <xsl:when test="$vloge/tei:vloga[. = 'Upodobljenec']">Da</xsl:when>
                           <xsl:otherwise>Ne</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <!-- poklic 1 -->
                     <td>
                        <xsl:variable name="poklic1" select="substring-after(tei:occupation[1]/@code,'#')"/>
                        <xsl:for-each select="//tei:category[@xml:id = $poklic1]">
                           <xsl:value-of select="tei:desc[1]"/>
                        </xsl:for-each>
                     </td>
                     <!-- poklic 2 -->
                     <td>
                        <xsl:variable name="poklic2" select="substring-after(tei:occupation[2]/@code,'#')"/>
                        <xsl:for-each select="//tei:category[@xml:id = $poklic2]">
                           <xsl:value-of select="tei:desc[1]"/>
                        </xsl:for-each>
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
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="datatables-representation">
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
         var columnIDs = [1, 2, 3, 4];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu rojstva upodobljenca</a>
            <div class="accordion-content rangeFilterWrapper" data-target="2" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu rojstva od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto rojstva (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto rojstva (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu smrti upodobljenca</a>
            <div class="accordion-content rangeFilterWrapper" data-target="3" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu smrti od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto smrti (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto smrti (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <table id="datatableRepresentation" class="display responsive nowrap targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
         <thead>
            <tr>
               <th>Maska</th>
               <th>Upodobljenec</th>
               <th>Rojstvo</th>
               <th>Smrt</th>
               <th>Poklic</th>
            </tr>
         </thead>
         <tfoot>
            <tr>
               <th></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
            </tr>
         </tfoot>
         <tbody>
            <!-- izpiše vse maske, pri kateri upodobljenec ni neznana oseba -->
            <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@xml:id='lido']/tei:list[@type='deathMask']/tei:item">
               <xsl:variable name="position" select="position()"/>
               <xsl:variable name="upodobljenecId" select="substring-after(tei:list/tei:item[contains(preceding-sibling::tei:label[1],'Upodobljenec')]/tei:ref/@target,'#')"/>
               <xsl:if test="not(tei:list/tei:item/tei:ref/@target='#pers.unknown')">
                  <tr>
                     <!-- zaporedje maske -->
                     <xsl:variable name="maskID" select="@xml:id"/>
                     <xsl:variable name="sistoryID" select="substring-after(@xml:id,'sistory-')"/>
                     <xsl:variable name="path2lido" select="concat('../../LIDO/',$sistoryID,'/metadata.xml')"/>
                     <td data-order="{$position}">
                        <xsl:variable name="chapterID" select="ancestor::tei:div[@type ='lido']/@xml:id"/>
                        <a>
                           <xsl:attribute name="href">
                              <!-- dodana relativna pot v okviru SIstory -->
                              <xsl:variable name="sistoryPath">
                                 <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                    <!--<xsl:call-template name="sistoryPath">
                                       <xsl:with-param name="chapterID" select="@chapterID"/>
                                    </xsl:call-template>-->
                                 </xsl:if>
                              </xsl:variable>
                              <xsl:sequence select="concat($sistoryPath,$chapterID,$standardSuffix,'#',$maskID)"/>
                           </xsl:attribute>
                           <xsl:value-of select="$position"/>
                        </a>
                     </td>
                     <!-- podatki o osebi -->
                     <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type ='listPerson']/tei:listPerson/tei:person[@xml:id=$upodobljenecId]">
                        <!-- Priimek in ime -->
                        <td>
                           <xsl:for-each select="tei:persName[1]">
                              <xsl:choose>
                                 <xsl:when test="not(child::*)">
                                    <xsl:value-of select="."/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="tei:surname"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="tei:forename"/>
                                    <xsl:if test="tei:addName">
                                       <xsl:value-of select="concat(' - ',tei:addName)"/>
                                    </xsl:if>
                                    <xsl:if test="tei:genName">
                                       <xsl:value-of select="concat(' ',tei:genName)"/>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each>
                        </td>
                        <!-- leto rojstva -->
                        <td>
                           <xsl:value-of select="tokenize(tei:birth/tei:date/@when,'-')[1]"/>
                        </td>
                        <!-- leto smrti -->
                        <td>
                           <xsl:value-of select="tokenize(tei:death/tei:date/@when,'-')[1]"/>
                        </td>
                        <!-- poklic (samo prvi) -->
                        <td>
                           <xsl:variable name="poklic1" select="substring-after(tei:occupation[1]/@code,'#')"/>
                           <xsl:for-each select="//tei:category[@xml:id = $poklic1]">
                              <xsl:value-of select="tei:desc[1]"/>
                           </xsl:for-each>
                        </td>
                     </xsl:for-each>
                  </tr>
               </xsl:if>
            </xsl:for-each>
         </tbody>
      </table>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
   <xsl:template name="datatables-representation-persons">
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
         var columnIDs = [2, 3, 4, 5];
      </script>
      
      <ul class="accordion" data-accordion="" data-allow-all-closed="true">
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu rojstva upodobljenca</a>
            <div class="accordion-content rangeFilterWrapper" data-target="2" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu rojstva od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto rojstva (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto rojstva (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
         <li class="accordion-item" data-accordion-item="">
            <a href="#" class="accordion-title">Filtriraj po letu smrti upodobljenca</a>
            <div class="accordion-content rangeFilterWrapper" data-target="3" data-tab-content="">
               <div class="row">
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-right middle">Filtriraj po letu smrti od</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMinValue" maxlength="4" placeholder="Leto smrti (min)"/>
                  </div>
                  <div class="small-3 columns">
                     <label for="middle-label" class="text-center middle">do</label>
                  </div>
                  <div class="small-3 columns">
                     <input type="text" class="rangeMaxValue" maxlength="4" placeholder="Leto smrti (max)"/>
                  </div>
                  <div class="small-12 columns" style="text-align: right;">
                     <a class="clearRangeFilter" href="#">Počisti filter</a>
                  </div>
               </div>
            </div>
         </li>
      </ul>
      
      <table id="datatableRepresentationPersons" class="display responsive nowrap targetTable" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
         <thead>
            <tr>
               <th>Oseba</th>
               <th>Upodobljenec</th>
               <th>Rojstvo</th>
               <th>Smrt</th>
               <th>Poklic</th>
               <th>Št. mask</th>
            </tr>
         </thead>
         <tfoot>
            <tr>
               <th></th>
               <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
            </tr>
         </tfoot>
         <tbody>
            <xsl:for-each-group select="ancestor::tei:text/tei:body/tei:div[@xml:id='lido']/tei:list[@type='deathMask']/tei:item" group-by="tei:list/tei:item[contains(preceding-sibling::tei:label[1],'Upodobljenec')]/tei:ref/@target">
               <xsl:if test="not(current-grouping-key() = '#pers.unknown')">
                  <xsl:variable name="upodobljenecId" select="substring-after(current-grouping-key(),'#')"/>
                  <xsl:variable name="stMask" select="count(current-group())"/>
                  <tr>
                     <xsl:for-each select="ancestor::tei:text/tei:body/tei:div[@type ='listPerson']/tei:listPerson/tei:person">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:if test="@xml:id = $upodobljenecId">
                           <!-- Zaporedje -->
                           <td data-order="{$position}">
                              <xsl:variable name="chapterID" select="ancestor::tei:div[@type ='listPerson']/@xml:id"/>
                              <a>
                                 <xsl:attribute name="href">
                                    <!-- dodana relativna pot v okviru SIstory -->
                                    <xsl:variable name="sistoryPath">
                                       <xsl:if test="$chapterAsSIstoryPublications='true'">
                                          <xsl:value-of select="concat('/cdn/publikacije/',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1,'-',(xs:integer(round(number($SISTORYID)) div 1000) * 1000) + 1000,'/',$SISTORYID,'/')"/>
                                          <!--<xsl:call-template name="sistoryPath">
                                       <xsl:with-param name="chapterID" select="@chapterID"/>
                                    </xsl:call-template>-->
                                       </xsl:if>
                                    </xsl:variable>
                                    <xsl:sequence select="concat($sistoryPath,$chapterID,$standardSuffix,'#',$upodobljenecId)"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="$position"/>
                              </a>
                           </td>
                           <!-- Priimek in ime -->
                           <td>
                              <xsl:for-each select="tei:persName[1]">
                                 <xsl:choose>
                                    <xsl:when test="not(child::*)">
                                       <xsl:value-of select="."/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="tei:surname"/>
                                       <xsl:text>, </xsl:text>
                                       <xsl:value-of select="tei:forename"/>
                                       <xsl:if test="tei:addName">
                                          <xsl:value-of select="concat(' - ',tei:addName)"/>
                                       </xsl:if>
                                       <xsl:if test="tei:genName">
                                          <xsl:value-of select="concat(' ',tei:genName)"/>
                                       </xsl:if>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:for-each>
                           </td>
                           <!-- leto rojstva -->
                           <td>
                              <xsl:value-of select="tokenize(tei:birth/tei:date/@when,'-')[1]"/>
                           </td>
                           <!-- leto smrti -->
                           <td>
                              <xsl:value-of select="tokenize(tei:death/tei:date/@when,'-')[1]"/>
                           </td>
                           <!-- poklic (samo prvi) -->
                           <td>
                              <xsl:variable name="poklic1" select="substring-after(tei:occupation[1]/@code,'#')"/>
                              <xsl:for-each select="//tei:category[@xml:id = $poklic1]">
                                 <xsl:value-of select="tei:desc[1]"/>
                              </xsl:for-each>
                           </td>
                           <!-- št. mask -->
                           <td>
                              <xsl:value-of select="$stMask"/>
                           </td>
                        </xsl:if>
                     </xsl:for-each>
                  </tr>
               </xsl:if>
            </xsl:for-each-group>
         </tbody>
      </table>
      
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
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
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc/>
   </xsldoc:doc>
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
   
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc> Ker sta pri body poglavjih samo dva div z vsebino, poenostavim prvotni template </xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="nav-body-head">Seznama</xsl:template>
   
</xsl:stylesheet>
