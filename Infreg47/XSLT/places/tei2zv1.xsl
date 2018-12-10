<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:cc="http://creativecommons.org/ns#" 
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" 
    xmlns:gn="http://www.geonames.org/ontology#" 
    xmlns:owl="http://www.w3.org/2002/07/owl#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    exclude-result-prefixes="xs tei cc foaf gn owl rdf rdfs wgs84_pos geo"
    version="2.0">
    
    <!-- Izhodiščni dokument je vsakokratni Verlustliste-*.xml -->
    
    <xsl:function name="tei:OR" as="xs:string">
        <xsl:param name="ident"/>
        <xsl:choose>
            <xsl:when test="$ident='ORKrn'">../TEI/Ortsrepertorium/OR-Krn-1910.xml</xsl:when>
            <xsl:when test="$ident='ORStm'">../TEI/Ortsrepertorium/OR-Stm-1910-SI.xml</xsl:when>
            <xsl:when test="$ident='ORKtn'">../TEI/Ortsrepertorium/OR-Ktn-1910-SI.xml</xsl:when>
            <xsl:when test="$ident='ORIst'">../TEI/Ortsrepertorium/OR-Ist-1910-SI.xml</xsl:when>
            <xsl:when test="$ident='ORGrz'">../TEI/Ortsrepertorium/OR-Grz-1910-SI.xml</xsl:when>
            <xsl:otherwise>
                <xsl:message>Unknown OR preffix <xsl:value-of select="$ident"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
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
        <header>"domovinska"</header>
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
        <header>"izvor"</header>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="$headers/header" separator="{$delimeter}"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:listPerson"/>
    </xsl:template>
    
    <xsl:template match="tei:TEI/tei:text/tei:body/tei:listPerson">
        <!-- Procesiram samo osebe, ki:
             - nimajo sameAs atributa (ta ukrep samo začasen: dokler vsi popravki (dvojniki) niso jasno označeni)
             - so umrle
             - so bile pristojne na ozemlju sedanje slovenije
        -->
        <xsl:for-each select="tei:person[not(@sameAs)][tei:event[@type='death']][tei:birth/tei:placeName[@key='SI']]">
            <xsl:variable name="personID" select="@xml:id"/>
            <xsl:variable name="publicationDate" select="substring-after(substring-before($personID,'_'),'vll.')"/>
            <xsl:variable name="issue" select="substring-before(substring-after($personID,'_'),'.')"/>
            <xsl:variable name="priimek">
                <xsl:choose>
                    <xsl:when test="tei:persName[1]/tei:surname[@type]">
                        <xsl:for-each select="tei:persName[1]/tei:surname[@type='true']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:persName[1]/tei:surname">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="tei:persName[1]/tei:roleName">
                    <xsl:text>, </xsl:text>
                    <xsl:for-each select="tei:persName[1]/tei:roleName">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="priimek2">
                <xsl:choose>
                    <xsl:when test="tei:persName[1]/tei:addName[@type]">
                        <xsl:for-each select="tei:persName[1]/tei:addName[@type='true']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:persName[1]/tei:addName">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ime">
                <xsl:choose>
                    <xsl:when test="tei:persName[1]/tei:forename[@type]">
                        <xsl:for-each select="tei:persName[1]/tei:forename[@type='true']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:persName[1]/tei:forename">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="starsi">
                <xsl:choose>
                    <xsl:when test="tei:persName[2][@type='father']/tei:forename[@type]">
                        <xsl:for-each select="tei:persName[2][@type='father']/tei:forename[@type='true']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:persName[2][@type='father']/tei:forename">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rojstvo">
                <xsl:choose>
                    <xsl:when test="tei:birth/tei:date[@when]">
                        <xsl:value-of select="tei:birth/tei:date/@when"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="tei:birth/tei:date"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- procesiram kraje -->
            <xsl:variable name="placeName">
                <xsl:choose>
                    <!-- vsi kraji (region in settlement) imajo povezavo na krajevne repertorije -->
                    <xsl:when test="tei:birth/tei:placeName[@precision='high']">
                        <xsl:variable name="OR-preffix" select="substring-before(tei:birth/tei:placeName[@precision='high']/@corresp,':')"/>
                        <xsl:variable name="OR-suffix" select="substring-after(tei:birth/tei:placeName[@precision='high']/@corresp,':')"/>
                        <xsl:variable name="OR-document" select="tei:OR($OR-preffix)"/>
                        <xsl:variable name="placeNameType" select="tei:birth/tei:placeName[@precision='high']/@type"/>
                        <xsl:for-each select="document($OR-document)//tei:place[@xml:id=$OR-suffix]">
                            <!-- Možne vrednosti: region, municipality, settlement, partOf -->
                            <xsl:if test="$placeNameType='region'">
                                <!-- če je samo region, je s tem označeno avtonomno mesto -->
                                <!-- v polje obcina se v resnici vpisuje politični okraj, ampak v tem primeru tudi avtonomno mesto  -->
                                <obcina>
                                    <!-- self -->
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if test="@ana ='#ad.stadt'">
                                        <xsl:text> (mesto)</xsl:text>
                                    </xsl:if>
                                </obcina>
                            </xsl:if>
                            <xsl:if test="$placeNameType='municipality'">
                                <!-- v polje obcina se v resnici vpisuje politični okraj -->
                                <obcina>
                                    <!-- ancestor bezirk -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </obcina>
                                <domovinska>
                                    <!-- self -->
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </domovinska>
                            </xsl:if>
                            <xsl:if test="$placeNameType='settlement' or $placeNameType='partOf'">
                                <!-- v polje obcina se v resnici vpisuje politični okraj -->
                                <obcina>
                                    <!-- ancestor bezirk -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </obcina>
                                <domovinska>
                                    <!-- ancestor gemeinde -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </domovinska>
                                <!-- Kraj ali pa del kraja -->
                                <bivalisce>
                                    <!-- self -->
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </bivalisce>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="tei:birth/tei:placeName[@precision='medium']">
                        <xsl:variable name="OR-preffix" select="substring-before(tei:birth/tei:placeName[@precision='medium']/@corresp,':')"/>
                        <xsl:variable name="OR-suffix" select="substring-after(tei:birth/tei:placeName[@precision='medium']/@corresp,':')"/>
                        <xsl:variable name="OR-document" select="tei:OR($OR-preffix)"/>
                        <xsl:variable name="placeNameType" select="tei:birth/tei:placeName[@precision='medium']/@type"/>
                        <xsl:variable name="settlements">
                            <xsl:for-each select="tei:birth/tei:placeName[@precision='medium']/tei:settlement">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:for-each select="document($OR-document)//tei:place[@xml:id=$OR-suffix]">
                            <!-- Možne vrednosti: region, judicial, municipality, settlement, partOf (zadnja vrednost v tem primeru ni bila prisotna) -->
                            <xsl:if test="$placeNameType='region' or $placeNameType='judicial'">
                                <!-- v polje obcina se v resnici vpisuje politični okraj -->
                                <!-- ker nimamo podatka za nižjo upravno enoto kot je sodni okraj, ga vseeno vnesemo v polje za okraj/obcino -->
                                <obcina>
                                    <!-- self -->
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </obcina>
                                <xsl:if test="string-length($settlements) gt 0">
                                    <bivalisce>
                                        <xsl:value-of select="$settlements"/>
                                    </bivalisce>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="$placeNameType='municipality'">
                                <obcina>
                                    <!-- ancestor bezirk -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </obcina>
                                <domovinska>
                                    <!-- self -->
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </domovinska>
                            </xsl:if>
                            <xsl:if test="$placeNameType='settlement'">
                                <obcina>
                                    <!-- ancestor bezirk -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.bezirk']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </obcina>
                                <domovinska>
                                    <!-- ancestor gemeinde -->
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ancestor::tei:place[@ana='#ad.gemeinde']/tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </domovinska>
                                <bivalisce>
                                    <xsl:choose>
                                        <xsl:when test="tei:placeName[1][@key]">
                                            <xsl:variable name="geonamesId" select="tei:placeName[1]/@key"/>
                                            <xsl:variable name="geonemes-file" select="concat('http://sws.geonames.org/',$geonamesId,'/about.rdf')"/>
                                            <xsl:variable name="geonamesRDF" select="document($geonemes-file, /)"/>
                                            <xsl:value-of select="$geonamesRDF/rdf:RDF/gn:Feature/gn:name"/>
                                            <xsl:if test="$geonamesRDF/rdf:RDF/gn:Feature[gn:countryCode != 'SI']">
                                                <xsl:value-of select="concat(' (',$geonamesRDF/rdf:RDF/gn:Feature/gn:countryCode,')')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="tei:placeName[@xml:lang='slv']">
                                                    <xsl:value-of select="tei:placeName[@xml:lang='slv']"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="tei:placeName[1]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </bivalisce>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- kraji (placeName), ki niso bili mapirani v krajevne repertorije [@precision='low'], ker:
                         - jih nismo znali pravilno mapirati (tako region kot settlement),
                         - je bila označena samo dežela [@type='country']
                    -->
                    <xsl:when test="tei:birth/tei:placeName[@precision='low'][not(@type='country')]">
                        <xsl:if test="tei:birth/tei:placeName[@precision='low']/tei:region">
                            <obcina>
                                <xsl:for-each select="tei:birth/tei:placeName[@precision='low']/tei:region">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </obcina>
                        </xsl:if>
                        <xsl:if test="tei:birth/tei:placeName[@precision='low']/tei:settlement">
                            <bivalisce>
                                <xsl:for-each select="tei:birth/tei:placeName[@precision='low']/tei:settlement">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </bivalisce>
                        </xsl:if>
                    </xsl:when>
                    <!-- če pa je označena samo dežela, potem ne naredimo nič -->
                    <xsl:when test="tei:birth/tei:placeName[@precision='low'][@type='country']">
                        <!-- ne procesiram -->
                    </xsl:when>
                    <!-- kraji, ki smo jih sicer našli v krajevnih repertorijih, vendar je isti kraj razdeljen v več administrativnih enot (npr. občin) -->
                    <!-- po potrebi te kraje po pretvorbi ročno popravi v bazi zv1 -->
                    <xsl:when test="tei:birth/tei:placeName[@precision='unknown']">
                        <xsl:if test="tei:birth/tei:placeName[@precision='unknown']/tei:region">
                            <obcina>
                                <xsl:for-each select="tei:birth/tei:placeName[@precision='unknown']/tei:region">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </obcina>
                        </xsl:if>
                        <xsl:if test="tei:birth/tei:placeName[@precision='unknown']/tei:settlement">
                            <bivalisce>
                                <xsl:for-each select="tei:birth/tei:placeName[@precision='low']/tei:settlement">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </bivalisce>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Unknown placeName annotation (person ID <xsl:value-of select="$personID"/>).</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="bivalisce">
                <!-- če je povezava na krajevni repertorij, je tukaj najprej kraj ali del kraja -->
                <!-- če ni povezave na krajevni repertorij, je tukaj settlement -->
                <xsl:value-of select="$placeName/bivalisce"/>
                <!-- če je povezava na krajevni repertorij, je tukaj dodatno še enkrat občina (domovinska) -->
                <xsl:if test="$placeName/domovinska and $placeName/bivalisce">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:value-of select="$placeName/domovinska"/>
                <!-- zaradi zv1 iskalnika sem dodam še enkrat tudi vsa avtonomna mesta -->
                <xsl:if test="matches($placeName/obcina,'\s\(mesto\)')">
                    <xsl:value-of select="substring-before($placeName/obcina,' (mesto)')"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="obcina">
                <!-- če je povezava na krajevni repertorij, je tukaj politični okraj -->
                <!-- če ni povezave na krajevni repertorij, je tukaj region -->
                <xsl:value-of select="$placeName/obcina"/>
            </xsl:variable>
            <xsl:variable name="domovinska">
                <!-- če je povezava na krajevni repertorij, je tukaj občina -->
                <xsl:value-of select="$placeName/domovinska"/>
            </xsl:variable>
            <xsl:variable name="dezela">
                <xsl:for-each select="tei:birth/tei:placeName">
                    <xsl:choose>
                        <xsl:when test="@corresp">
                            <xsl:choose>
                                <xsl:when test="contains(@corresp,'ORKrn:')">Kranjska</xsl:when>
                                <xsl:when test="contains(@corresp,'ORStm:')">Štajerska</xsl:when>
                                <xsl:when test="contains(@corresp,'ORKtn:')">Koroška</xsl:when>
                                <xsl:when test="contains(@corresp,'ORIst:')">Istra</xsl:when>
                                <xsl:when test="contains(@corresp,'ORGrz:')">Goriška in Gradiška</xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="tei:country='Krain'">Kranjska</xsl:when>
                                <xsl:when test="tei:country='Steiermark'">Štajerska</xsl:when>
                                <xsl:when test="tei:country='Kärnten'">Koroška</xsl:when>
                                <xsl:when test="tei:country='Küstenland'">Primorska</xsl:when>
                                <xsl:when test="tei:country[contains(.,'Görz')]">Goriška in Gradiška</xsl:when>
                                <xsl:when test="tei:country='Istrien'">Istra</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="tei:country"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="smrt">
                <xsl:choose>
                    <xsl:when test="tei:event[@type='death']/tei:desc/tei:date">
                        <xsl:for-each select="tei:event[@type='death']/tei:desc/tei:date">
                            <xsl:choose>
                                <xsl:when test="@when">
                                    <xsl:for-each select="@when">
                                        <xsl:call-template name="format-date"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="@notBefore and @notAfter">
                                    <xsl:text>med </xsl:text>
                                    <xsl:for-each select="@notBefore">
                                        <xsl:call-template name="format-date"/>
                                    </xsl:for-each>
                                    <xsl:text> in </xsl:text>
                                    <xsl:for-each select="@notAfter">
                                        <xsl:call-template name="format-date"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="@notBefore and not(@notAfter)">
                                    <xsl:text>ne pred </xsl:text>
                                    <xsl:for-each select="@notBefore">
                                        <xsl:call-template name="format-date"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="not(@notBefore) and @notAfter">
                                    <xsl:text>ne po </xsl:text>
                                    <xsl:for-each select="@notAfter">
                                        <xsl:call-template name="format-date"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="not(@when) and not(@notBefore) and not(@notAfter)">
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>Unknown date of death (person @xml:id: <xsl:value-of select="$personID"/>)</xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- če ni datuma smrti, določim, da je oseba umrla pred datumom objave dotične Verlustliste -->
                    <xsl:otherwise>
                        <xsl:variable name="year" select="substring($publicationDate,1,4)"/>
                        <xsl:variable name="month" select="substring($publicationDate,5,2)"/>
                        <xsl:variable name="day" select="substring($publicationDate,7,2)"/>
                        <xsl:variable name="deathdate" select="concat($year,'-',$month,'-',$day)"/>
                        <xsl:text>pred </xsl:text>
                        <xsl:for-each select="$deathdate">
                            <xsl:call-template name="format-date"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="krajSmrti">
                <xsl:for-each select="tei:event[@type='death']/tei:desc/tei:placeName">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="pokop" select="tei:event[@type='burial']/tei:desc/tei:placeName"/>
            <xsl:variable name="cin">
                <xsl:choose>
                    <xsl:when test="tei:socecStatus[@type]">
                        <xsl:for-each select="tei:socecStatus[@type='true']">
                            <xsl:value-of select="translate(.,'&quot;','')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:socecStatus">
                            <xsl:value-of select="translate(.,'&quot;','')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="enota">
                <xsl:choose>
                    <xsl:when test="tei:affiliation[@type]">
                        <xsl:for-each select="tei:affiliation[@type='true']">
                            <xsl:value-of select="translate(.,'&quot;','')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tei:affiliation">
                            <xsl:value-of select="translate(.,'&quot;','')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Verlustliste; št. 622; 15; http://kkkkkkkkkk -->
            <xsl:variable name="viri">
                <xsl:text>Verlustliste, št. </xsl:text>
                <xsl:value-of select="$issue"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before(substring-after(@source,'seite='),'&amp;')"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="@source"/>
                <xsl:text>, ID::</xsl:text>
                <xsl:value-of select="$personID"/>
            </xsl:variable>
            <xsl:variable name="ostalo">
                <xsl:if test="tei:event[@type='burial']/tei:desc/tei:date/@when">
                    <xsl:text>Datum pogreba: </xsl:text>
                    <xsl:for-each select="tei:event[@type='burial']/tei:desc/tei:date/@when">
                        <xsl:call-template name="format-date"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
            
            <!-- priimek1 -->
            <xsl:value-of select="concat('&quot;',$priimek,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- priimek2 -->
            <xsl:value-of select="concat('&quot;',$priimek2,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- ime -->
            <xsl:value-of select="concat('&quot;',$ime,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- starši -->
            <xsl:value-of select="concat('&quot;',$starsi,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- datum rojstva -->
            <xsl:value-of select="concat('&quot;',$rojstvo,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- kraj rojstva -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- župnija -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- bivališče -->
            <xsl:value-of select="concat('&quot;',$bivalisce,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- okraj / občina -->
            <xsl:value-of select="concat('&quot;',$obcina,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- dežela -->
            <xsl:value-of select="concat('&quot;',$dezela,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- domovinska -->
            <xsl:value-of select="concat('&quot;',$domovinska,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- stan -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- vpoklic -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- datum smrti -->
            <xsl:value-of select="concat('&quot;',$smrt,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- kraj smrti -->
            <xsl:value-of select="concat('&quot;',$krajSmrti,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- vzrok smrti -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- kraj pokopa -->
            <xsl:value-of select="concat('&quot;',$pokop,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- čin -->
            <xsl:value-of select="concat('&quot;',$cin,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- enota -->
            <xsl:value-of select="concat('&quot;',$enota,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- ostalo -->
            <xsl:value-of select="concat('&quot;',$ostalo,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- viri -->
            <xsl:value-of select="concat('&quot;',$viri,'&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- moje opombe -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>,</xsl:text>
            <!-- izvor -->
            <xsl:value-of select="concat('&quot;','&quot;')"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
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
                <xsl:value-of select="format-date(xs:date(.),'[D]. [M]. [Y]')"/>
            </xsl:when>
            <!-- drugače je samo mesec -->
            <xsl:otherwise>
                <xsl:variable name="month" select="tokenize(.,'-')[2]"/>
                <xsl:value-of select="concat($meseci/mesec[@n = $month],' ',tokenize(.,'-')[1])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>