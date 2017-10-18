<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- TODO: Kam naj dam addName? Kam datum pokopa? (trenutno dal v Druge podatke - ostalo)
         Kraj rojstva in bivališče: Če sta oba ista, kako se vpisuje? Jaz sem v tem primeru vpisal samo kraj rojstva.
    -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:param name="delimeter" select="','"/>
    <xsl:variable name="headers">
        <header>"priimek"</header>
        <header>"priimek2"</header>
        <header>"ime"</header>
        <header>"starsi"</header>
        <!-- datum rojstva -->
        <header>"rojstvo"</header>
        <header>"KrajRojstva"</header>
        <header>"zupnija"</header>
        <header>"bivalisce"</header>
        <!-- občina, okraj bivanja -->
        <header>"obcina"</header>
        <header>"dezela"</header>
        <header>"stan"</header>
        <header>"vpoklic"</header>
        <header>"smrt"</header>
        <header>"KrajSmrti"</header>
        <header>"vzrok"</header>
        <header>"pokop"</header>
        <header>"cin"</header>
        <header>"enota"</header>
        <header>"ostalo"</header>
        <header>"viri"</header>
        <header>"opombe"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div/tei:listPerson"/>
    </xsl:template>
    
    <xsl:template match="tei:TEI/tei:text/tei:body/tei:div/tei:listPerson">
        <xsl:for-each select="tei:person">
            <xsl:variable name="priimek" select="tei:persName/tei:surname"/>
            <xsl:variable name="ime">
                <xsl:for-each select="tei:persName/tei:forename">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rojstvo" select="tei:birth/tei:date"/>
            <xsl:variable name="krajRojstva">
                <xsl:for-each select="tei:residence[1]/tei:settlement">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="bivalisce">
                <xsl:for-each select="tei:residence[2]/*">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="obcina">
                <xsl:for-each select="tei:residence[1]/tei:region">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="dezela" select="tei:residence[1]/tei:country"/>
            <xsl:variable name="smrt" select="tei:death/tei:date"/>
            <xsl:variable name="krajSmrti" select="tei:death/tei:placeName"/>
            <xsl:variable name="vzrok" select="tei:death/tei:note"/>
            <xsl:variable name="pokop" select="tei:event/tei:desc/tei:placeName"/>
            <xsl:variable name="cin" select="tei:socecStatus"/>
            <xsl:variable name="ostalo">
                <xsl:if test="tei:event/tei:desc/tei:date/@when">
                    <xsl:text>Datum pogreba: </xsl:text>
                    <xsl:value-of select="tei:event/tei:desc/tei:date/@when"/>
                </xsl:if>
            </xsl:variable>
            
            <xsl:value-of select="concat('&quot;',$priimek,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- priimek2 -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$ime,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- starši -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$rojstvo,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$krajRojstva,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- zupnija -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$bivalisce,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$obcina,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$dezela,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- stan -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- vpklic -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$smrt,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$krajSmrti,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$vzrok,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$pokop,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$cin,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- enota -->
            <xsl:value-of select="concat('&quot;','47. štajerski pešpolk','&quot;')"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="concat('&quot;',$ostalo,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- viri -->
            <xsl:value-of select="concat('&quot;','Vogelsang, Ludwig Freiherrn von. Das steirische Infanterieregiment Nr. 47 im Weltkrieg. Graz: Leykam-Verlag, 1932, str. 805-948','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- moje opombe -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>