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
   <!-- ../../../  -->
   <xsl:param name="path-general">http://www2.sistory.si/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/to.xsl -->
   <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Beograd/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">true</xsl:param>
   
   <xsl:param name="documentationLanguage">en</xsl:param>
   
   <xsl:param name="element-gloss-teiHeader-lang">en</xsl:param>
   
   <xsl:param name="languages-locale">true</xsl:param>
   
   <!-- odstranim pri spodnjih param true -->
   <xsl:param name="numberFigures"></xsl:param>
   <xsl:param name="numberFrontTables"></xsl:param>
   <xsl:param name="numberHeadings"></xsl:param>
   <xsl:param name="numberParagraphs"></xsl:param>
   <xsl:param name="numberTables"></xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description">Slovenci v Beogradu, Словенци у Београду, Slovenes in Belgrade</xsl:param>
   <xsl:param name="keywords">Belgrad, Slovenia, history</xsl:param>
   <xsl:param name="title">Slovenci v Beogradu, Словенци у Београду, Slovenes in Belgrade</xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Ne procesiram štetja besed v kolofonu</desc>
   </doc>
   <xsl:template name="countWords"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:titleStmt" mode="kolofon">
      <!-- odstranim procesiranje tei:avtor -->
      <!-- Naslov mora vedno biti, zato ne preverjam, če obstaja. -->
      <p itemprop="name">
         <xsl:for-each select="tei:title[1]">
            <b><xsl:value-of select="."/></b>
            <xsl:if test="following-sibling::tei:title">
               <xsl:text> / </xsl:text>
            </xsl:if>
            <xsl:for-each select="following-sibling::tei:title">
               <b><xsl:value-of select="."/></b>
               <xsl:if test="position() != last()">
                  <xsl:text> / </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </xsl:for-each>
      </p>
      <br/>
      <br/>
      <xsl:apply-templates select="tei:respStmt" mode="kolofon"/>
      <br/>
      <xsl:if test="tei:funder">
         <p itemprop="funder">
            <xsl:value-of select="tei:funder"/>
         </p>
      </xsl:if>
      <br/>
   </xsl:template>
   
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>V css in javascript Hook dodam imageViewer</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="cssHook">
      <xsl:if test="$title-bar-sticky = 'true'">
         <xsl:value-of select="concat($path-general,'publikacije/themes/css/foundation/6/sistory-sticky_title_bar.css')"/>
      </xsl:if>
      <link href="http://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'publikacije/themes/plugin/TipueSearch/6.1/tipuesearch/css/normalize.css')}" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'publikacije/themes/css/plugin/TipueSearch/6.1/my-tipuesearch.css')}"  rel="stylesheet" type="text/css" />
      <!-- dodan imageViewer -->
      <link href="{concat($path-general,'publikacije/themes/plugin/ImageViewer/1.1.3/imageviewer.css')}"  rel="stylesheet" type="text/css" />
   </xsl:template>
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>[html] Hook where extra Javascript functions can be defined</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="javascriptHook">
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/jquery.js')}"></script>
      <!-- za highcharts -->
      <xsl:if test="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']]">
         <xsl:variable name="jsfile" select="//tei:figure[@type = 'chart'][tei:graphic[@mimeType = 'application/javascript']][1]/tei:graphic[@mimeType = 'application/javascript']/@url"/>
         <xsl:variable name="chart-jsfile" select="document($jsfile)/html/body/script[1]/@src"/>
         <script src="{$chart-jsfile[1]}"></script>
      </xsl:if>
      <!-- za back-to-top in highcharts je drugače potrebno dati jquery, vendar sedaj ne rabim dodajati jquery kodo,
         ker je že vsebovana zgoraj -->
      <!-- dodan imageViewer -->
      <script src="{concat($path-general,'publikacije/themes/plugin/ImageViewer/1.1.3/imageviewer.js')}"></script>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Orbit - slides. Vedno so kodirani kot figure/figure</desc>
   </doc>
   <xsl:template match="tei:figure[@rend='orbit']">
      <!-- anchors -->
      <xsl:for-each select="tei:figure">
         <a id="{@xml:id}"></a>
      </xsl:for-each>
      <div class="row">
         <div class="small-12 medium-10 large-8 small-centered columns">
            <div class="orbit" role="region" aria-label="Slike, Pictures" data-orbit="">
               <div class="orbit-wrapper">
                  <div class="orbit-controls">
                     <button class="orbit-previous"><span class="show-for-sr">Previous Slide</span>&#9664;&#xFE0E;</button>
                     <button class="orbit-next"><span class="show-for-sr">Next Slide</span>&#9654;&#xFE0E;</button>
                  </div>
                  <ul class="orbit-container" id="{@xml:id}">
                     <xsl:for-each select="tei:figure">
                        <li>
                           <xsl:attribute name="class">
                              <xsl:choose>
                                 <xsl:when test="position() = 1">orbit-slide is-active</xsl:when>
                                 <xsl:otherwise>orbit-slide</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <figure class="orbit-figure" style="height: 400px; width: 600px;">
                              <img class="orbit-image imageviewer" src="{tei:graphic[contains(@url,'slide')]/@url}" data-high-res-src="{tei:graphic[contains(@url,'normal')]/@url}" alt="{normalize-space(tei:head)}"/>
                              <figcaption class="orbit-caption">
                                 <xsl:value-of select="normalize-space(tei:head)"/>
                              </figcaption>
                           </figure>
                        </li>
                     </xsl:for-each>
                  </ul>
               </div>
               <nav class="orbit-bullets">
                  <xsl:for-each select="tei:figure">
                     <button data-slide="{position() - 1}">
                        <xsl:if test="position() = 1">
                           <xsl:attribute name="class">is-active</xsl:attribute>
                        </xsl:if>
                        <span class="show-for-sr">
                           <xsl:value-of select="normalize-space(tei:head)"/>
                        </span>
                     </button>
                  </xsl:for-each>
               </nav>
            </div>
         </div>
      </div>
   </xsl:template>
   
   <xsldoc:doc xmlns:xsldoc="http://www.oxygenxml.com/ns/doc/xsl">
      <xsldoc:desc>Dodam zaključni javascript za ImageViewer</xsldoc:desc>
   </xsldoc:doc>
   <xsl:template name="bodyEndHook">
      <script type="text/javascript">
         
         $(function () {
           var viewer = ImageViewer();
             $('.imageviewer').click(function () {
               var imgSrc = this.src,
               highResolutionImage = $(this).data('high-res-src');
               viewer.show(imgSrc, highResolutionImage);
            });
          });
      </script>
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/what-input.js')}"></script>
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/foundation.min.js')}"></script>
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/app.js')}"></script>
      <!-- back-to-top -->
      <script src="{concat($path-general,'publikacije/themes/js/plugin/back-to-top/back-to-top.js')}"></script>
   </xsl:template>
   
   
</xsl:stylesheet>
