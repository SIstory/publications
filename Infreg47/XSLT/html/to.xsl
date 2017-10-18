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
   <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Infreg47/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">true</xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description">Smrtne žrtve 47. štajerskega pešpolka med prvo svetovno vojno</xsl:param>
   <xsl:param name="keywords">1. svetovna vojna, Avstro-Ogrska, smrtne žrtve</xsl:param>
   <xsl:param name="title">Smrtne žrtve 47. štajerskega pešpolka med prvo svetovno vojno</xsl:param>
   
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
      <!-- DODAL SPODNJO SAMO ZA TO PRETVORBO! -->
      <!-- za generiranje datateble oseb -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons']">
         <xsl:call-template name="datatables-persons"/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="datatables-persons">
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
    $('#datatablePersons').DataTable( {
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
         <table id="datatablePersons" class="display" data-order="[[ 1, &quot;asc&quot; ]]" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Zaporedje</th>
                  <th>Priimek in ime</th>
                  <th>Položaj</th>
                  <th>Leto rojstva</th>
                  <th>Kraj rojstva</th>
                  <th>Okraj rojstva</th>
                  <th>Dežela rojstva</th>
                  <th>Bivališče</th>
                  <th>Datum smrti</th>
                  <th>Umrl najkasneje</th>
                  <th>Kraj smrti</th>
                  <th>Datum pogreba</th>
                  <th>Kraj pogreba</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th>Zaporedje</th>
                  <th>Priimek in ime</th>
                  <th>Položaj</th>
                  <th>Leto rojstva</th>
                  <th>Kraj rojstva</th>
                  <th>Okraj rojstva</th>
                  <th>Dežela rojstva</th>
                  <th>Bivališče</th>
                  <th>Datum smrti</th>
                  <th>Umrl najkasneje</th>
                  <th>Kraj smrti</th>
                  <th>Datum pogreba</th>
                  <th>Kraj pogreba</th>
               </tr>
            </tfoot>
            <tbody>
               <xsl:for-each select="ancestor::tei:text/tei:body/tei:div/tei:listPerson/tei:person">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <tr>
                     <!-- Zaporedje -->
                     <td data-order="{position()}">
                        <xsl:variable name="chapterID" select="ancestor::tei:div/@xml:id"/>
                        <a>
                           <xsl:attribute name="href">
                              <!-- dodana relativna pot v okviru SIstory -->
                              <xsl:variable name="sistoryPath">
                                 <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:call-template name="sistoryPath">
                                       <xsl:with-param name="chapterID" select="@chapterID"/>
                                    </xsl:call-template>
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
                     <!-- Položaj -->
                     <td>
                        <xsl:value-of select="tei:socecStatus"/>
                     </td>
                     <!-- Leto rojstva -->
                     <td>
                        <xsl:value-of select="tei:birth/tei:date/@when"/>
                     </td>
                     <!-- Kraj rojstva -->
                     <td>
                        <xsl:value-of select="tei:residence[1]/tei:settlement"/>
                     </td>
                     <!-- Okraj rojstva -->
                     <td>
                        <xsl:value-of select="tei:residence[1]/tei:region"/>
                     </td>
                     <!-- Dežela rojstva -->
                     <td>
                        <xsl:value-of select="tei:residence[1]/tei:country"/>
                     </td>
                     <!-- Bivališče -->
                     <td>
                        <xsl:for-each select="tei:residence[2]/*">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </td>
                     <!-- Datum smrti -->
                     <td>
                        <xsl:if test="tei:death/tei:date/@when or tei:death/tei:date/@notBefore">
                           <xsl:attribute name="data-search">
                              <xsl:value-of select="tei:death/tei:date/@when"/>
                              <!-- če pa ni @when, damo prvi možen datum -->
                              <xsl:value-of select="tei:death/tei:date/@notBefore"/>
                           </xsl:attribute>
                           <xsl:for-each select="tei:death/tei:date/@when">
                              <xsl:call-template name="format-date"/>
                           </xsl:for-each>
                        </xsl:if>
                     </td>
                     <!-- Umrl najkasneje -->
                     <td>
                        <xsl:if test="tei:death/tei:date/@notAfter">
                           <xsl:attribute name="data-search">
                              <xsl:value-of select="tei:death/tei:date/@notAfter"/>
                           </xsl:attribute>
                           <xsl:for-each select="tei:death/tei:date/@notAfter">
                              <xsl:call-template name="format-date"/>
                           </xsl:for-each>
                        </xsl:if>
                     </td>
                     <!-- Kraj smrti -->
                     <td>
                        <xsl:value-of select="tei:death/tei:placeName"/>
                     </td>
                     <!-- Datum pogreba -->
                     <td>
                        <xsl:if test="tei:event/tei:desc/tei:date/@when">
                           <xsl:attribute name="data-search">
                              <xsl:value-of select="tei:event/tei:desc/tei:date/@when"/>
                           </xsl:attribute>
                           <xsl:for-each select="tei:event/tei:desc/tei:date/@when">
                              <xsl:call-template name="format-date"/>
                           </xsl:for-each>
                        </xsl:if>
                     </td>
                     <!-- Kraj pogreba -->
                     <td>
                        <xsl:value-of select="tei:event/tei:desc/tei:placeName"/>
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
   
</xsl:stylesheet>
