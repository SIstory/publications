<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.sistory.si/schemas/sistory/"
    xmlns:sistory="http://www.sistory.si/schemas/sistory/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs sistory tei"
    version="2.0">
    
    <!-- naredim osnovni seznam posmrtnih mask s povezavami:
         - avtorjev na seznam oseb,
         - upodobljencev na seznam oseb,
         - povezava na SIstory
         - maske na LIDO metapodatke.
    -->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Določim sistory ID zadnje prejšnje pretvorbe. 
         Namen: ker se lahko pretvorjene kasneje popravlja na roko, ni potrebno, da že pregledane in morebiti urejene podatke še enkrat pretvarjamo -->
    <xsl:param name="processingFromSIstoryID">0</xsl:param>
    <!-- PAZI: nujno vnesi vrednost zgornjega parametra processingFromSIstoryID, drugače bo procesiral vse publication od 0 dalje
         Pretvorimo lahko točno določeno sistory publikacijo.
         Namen: Ker lahko v sistory naknadno popravljamo vpisane metapodatke, jih lahko na ta način še enkrat pretvorimo -->
    <xsl:param name="processingSIstoryID">0</xsl:param>
    <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Odlivanje_smrti/sources/</xsl:param>
    
    <xsl:variable name="osebe">
        <xsl:for-each select="document('../../Odlivanje_smrti.xml')/tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person/tei:persName">
            <xsl:variable name="ime">
                <xsl:for-each select="tei:forename">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()"> </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="priimek">
                <xsl:for-each select="tei:surname">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()"> </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <oseba xml:id="{parent::tei:person/@xml:id}">
                <xsl:choose>
                    <xsl:when test="tei:addName">
                        <xsl:value-of select="concat($ime,' ',$priimek,'-',tei:addName)"/>
                    </xsl:when>
                    <xsl:when test="tei:nameLink">
                        <xsl:value-of select="concat($ime,' ',tei:nameLink,' ',$priimek)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($ime,' ',$priimek)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </oseba>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="sistory:root">
        <xsl:result-document href="{$outputDir,'TEI_list.xml'}">
            <div type="lido" xml:id="lido">
                <head>Posmrtne maske</head>
                <list rend="ordered" type="deathMask">
                    <xsl:for-each select="sistory:publication[xs:integer(sistory:ID) gt xs:integer($processingFromSIstoryID)] | 
                        sistory:publication[xs:integer(sistory:ID) = xs:integer($processingSIstoryID)]">
                        <xsl:sort select="sistory:TITLE[@titleType='Title']"/>
                        <item xml:id="{concat('sistory-',sistory:ID)}">
                            <list type="gloss">
                                <label>Naziv</label>
                                <item>
                                    <xsl:value-of select="sistory:TITLE[@titleType='Title']"/>
                                </item>
                                <xsl:for-each select="sistory:CREATOR">
                                    <xsl:variable name="avtor" select="concat(sistory:IME,' ',sistory:PRIIMEK)"/>
                                    <label>Avtor</label>
                                    <item>
                                        <xsl:for-each select="$osebe/sistory:oseba[. = $avtor]">
                                            <ref target="{concat('#',@xml:id)}">
                                                <xsl:value-of select="$avtor"/>
                                            </ref>
                                        </xsl:for-each>
                                    </item>
                                </xsl:for-each>
                                <xsl:for-each select="sistory:SUBJECT">
                                    <xsl:variable name="upodobljenec" select="."/>
                                    <label>Upodobljenec</label>
                                    <item>
                                        <xsl:choose>
                                            <xsl:when test="contains(.,'Neznan')">
                                                <ref target="#pers.unknown">
                                                    <xsl:value-of select="$upodobljenec"/>
                                                </ref>
                                            </xsl:when>
                                            <!-- če vsebuje vejico, za katero npr. stoji genName kot Josip Vilfan, mlajši
                                                 potem procesiramo samo ime in priimek pred vejico
                                            -->
                                            <xsl:when test="contains(.,',')">
                                                <xsl:for-each select="$osebe/sistory:oseba[. = substring-before($upodobljenec,',')]">
                                                    <ref target="{concat('#',@xml:id)}">
                                                        <xsl:value-of select="$upodobljenec"/>
                                                    </ref>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each select="$osebe/sistory:oseba[. = $upodobljenec]">
                                                    <ref target="{concat('#',@xml:id)}">
                                                        <xsl:value-of select="$upodobljenec"/>
                                                    </ref>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </item>
                                </xsl:for-each>
                                <label>SIstory</label>
                                <item>
                                    <ref target="{concat('http://www.sistory.si/',sistory:URN)}">
                                        <xsl:value-of select="concat('http://hdl.handle.net/',sistory:URN)"/>
                                    </ref>
                                </item>
                                <label>LIDO metapodatki</label>
                                <item><ptr target="{concat('https://raw.githubusercontent.com/SIstory/publications/master/Odlivanje_smrti/LIDO/',sistory:ID,'/metadata.xml')}" type="LIDO"/></item>
                            </list>
                        </item>
                    </xsl:for-each>
                </list>
            </div>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>