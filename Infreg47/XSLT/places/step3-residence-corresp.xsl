<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni Infreg47.xml -->
    <!-- za person/birth/placeName iz places.xml poberem odgovarjajočo povezavo na krajevne repertorije -->
    
    <xsl:param name="doc-places">places.xml</xsl:param>
    
    <xsl:function name="tei:placeType" as="xs:string">
        <xsl:param name="ident"/>
        <xsl:choose>
            <!-- Administrative district or Statutory city -->
            <xsl:when test="string-length(string($ident)) = 2">region</xsl:when>
            <!-- Judicial district -->
            <xsl:when test="string-length(string($ident)) = 4">judicial</xsl:when>
            <!-- Municipality -->
            <xsl:when test="string-length(string($ident)) = 6">municipality</xsl:when>
            <!-- Place -->
            <xsl:when test="string-length(string($ident)) = 8">settlement</xsl:when>
            <!-- Local district -->
            <xsl:when test="string-length(string($ident)) = 10">partOf</xsl:when>
            <!-- neznani string -->
            <xsl:otherwise>unknown</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- samo tisti residence (ena oseba jih ima lahko več), ki imajo tudi country element -->
    <xsl:template match="tei:residence[tei:country]">
        <xsl:variable name="personID" select="ancestor::tei:person/@xml:id"/>
        <residence>
            <xsl:variable name="OR">
                <xsl:for-each select="document($doc-places)//tei:place[tei:idno[tokenize(normalize-space(.),' ') = $personID]]">
                    <xsl:variable name="placeType" select="if (@subtype) then @subtype else @type"/>
                    <xsl:variable name="countryKey" select="ancestor::tei:place[@type='country']/@subtype"/>
                    <xsl:choose>
                        <xsl:when test="@corresp">
                            <xsl:choose>
                                <xsl:when test="matches(@corresp,'\s')">
                                    <xsl:choose>
                                        <!-- če je precision z vrednostjo unknown, potem je isti kraj razdeljen na več upravnih enot (občin ali krajev) -->
                                        <!-- te možnosti trenutno nimam -->
                                        <xsl:when test="@precision">
                                            <place country="{$countryKey}" corresp="yes" type="{$placeType}" precision="{@precision}">
                                                <xsl:value-of select="@corresp"/>
                                            </place>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="tokenize(@corresp,' ')">
                                                <place country="{$countryKey}" corresp="yes" type="{if (position()=2) then 'municipality' else $placeType}" position="{position()}">
                                                    <xsl:value-of select="."/>
                                                </place>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <place country="{$countryKey}" corresp="yes" type="{$placeType}">
                                        <xsl:value-of select="@corresp"/>
                                    </place>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <place country="{$countryKey}" corresp="no" type="{$placeType}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:attribute name="key">
                <xsl:choose>
                    <!-- Na Koroškem je večina krajev na avstrijski strani, zato je kraj v današnji Sloveniji, že takrat, če je samo en place iz variable v sloveniji -->
                    <xsl:when test="contains($doc-places,'Karnten')">
                        <xsl:choose>
                            <xsl:when test="$OR/tei:place[@country='SI']">SI</xsl:when>
                            <xsl:otherwise>AT</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- V vseh drugih slovenskih delih dežel pa je večina krajev v sedanji Sloveniji -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$OR/tei:place[@country='AT']">AT</xsl:when>
                            <xsl:when test="$OR/tei:place[@country='HR']">HR</xsl:when>
                            <xsl:when test="$OR/tei:place[@country='IT']">IT</xsl:when>
                            <!-- drugače pa je vedno Slovenija -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <!-- z izjemo mesta Gorice, ki ga dam v Italijo -->
                                    <xsl:when test="$OR/tei:place[@country='SI'][@position] = 'ORGrz:c.02' and not($OR/tei:place[@country='SI'][not(@position)])">IT</xsl:when>
                                    <xsl:otherwise>SI</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <!-- če je precision z vrednostjo unknown, potem je isti kraj razdeljen na več upravnih enot (občin ali krajev) -->
                <xsl:when test="not($OR/tei:place[@corresp='no']) and $OR/tei:place[@corresp='yes'][@precision][not(@position)]">
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="$OR/tei:place[@corresp='yes'][@precision][not(@position)]"/>
                    </xsl:attribute>
                    <xsl:attribute name="precision">
                        <xsl:value-of select="$OR/tei:place[@corresp='yes'][not(@position)]/@precision"/>
                    </xsl:attribute>
                </xsl:when>
                <!-- običajna pretvorba: obstaja settlement v region in za oba je znana povezava na Ortsrepertorium -->
                <xsl:when test="not($OR/tei:place[@corresp='no']) and $OR/tei:place[@corresp='yes'][not(@precision)][not(@position)]">
                    <xsl:variable name="corresp">
                        <xsl:for-each select="$OR/tei:place[@corresp='yes'][not(@precision)][not(@position)]">
                            <xsl:sort order="ascending"/>
                            <xsl:if test="position() = last()">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:attribute name="type">
                        <xsl:value-of select="tei:placeType(substring-after($corresp,'c.'))"/>
                    </xsl:attribute>
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="$corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="precision">high</xsl:attribute>
                </xsl:when>
                <!-- isto kot prejšnji when, vendar v tem primeru obstaja tudi neznani kraj 
                     (zato je Ortsrepertorium povezava samo na okraj, ne pa na (neznani) kraj) -->
                <xsl:when test="$OR/tei:place[@corresp='no'] and $OR/tei:place[@corresp='yes'][not(@precision)][not(@position)]">
                    <xsl:variable name="corresp">
                        <xsl:for-each select="$OR/tei:place[@corresp='yes'][not(@precision)][not(@position)]">
                            <xsl:sort order="ascending"/>
                            <xsl:if test="position() = last()">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:attribute name="type">
                        <xsl:value-of select="tei:placeType(substring-after($corresp,'c.'))"/>
                    </xsl:attribute>
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="$corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="precision">medium</xsl:attribute>
                </xsl:when>
                <!-- Če za določen region ni nato naknadno določen še kraj, sklepamo, da je region v resnici glavno mesto (občina) te regije.
                     Npr. v primeru country (Krain), region (Laibach) je Ljubljana avtonomno mesto in ne okraj Ljubljana. -->
                <xsl:when test="not($OR/tei:place[@corresp='no']) and $OR/tei:place[@corresp='yes'][not(@precision)][@position] and not($OR/tei:place[@corresp='yes'][not(@precision)][not(@position)])">
                    <xsl:variable name="corresp">
                        <xsl:value-of select="$OR/tei:place[@corresp='yes'][not(@precision)][@position='2']"/>
                    </xsl:variable>
                    <xsl:attribute name="type">
                        <xsl:value-of select="tei:placeType(substring-after($corresp,'c.'))"/>
                    </xsl:attribute>
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="$corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="precision">high</xsl:attribute>
                </xsl:when>
                <!-- isto kot prejšnji when, vendar v tem primeru obstaja tudi neznani kraj -->
                <xsl:when test="$OR/tei:place[@corresp='no'] and $OR/tei:place[@corresp='yes'][not(@precision)][@position] and not($OR/tei:place[@corresp='yes'][not(@precision)][not(@position)])">
                    <xsl:variable name="corresp">
                        <!-- zato v tem primeru damo okraj (in ne avtonomno mesto oz. občino) -->
                        <xsl:value-of select="$OR/tei:place[@corresp='yes'][not(@precision)][@position='1']"/>
                    </xsl:variable>
                    <xsl:attribute name="type">
                        <xsl:value-of select="tei:placeType(substring-after($corresp,'c.'))"/>
                    </xsl:attribute>
                    <xsl:attribute name="corresp">
                        <xsl:value-of select="$corresp"/>
                    </xsl:attribute>
                    <xsl:attribute name="precision">medium</xsl:attribute>
                </xsl:when>
                <xsl:when test="$OR/tei:place[@corresp='no'] and not($OR/tei:place[@corresp='yes'])">
                    <xsl:attribute name="precision">low</xsl:attribute>
                </xsl:when>
                <!-- lahko je samo podatek o deželi, brez podatka o regiji in kraju 
                     (velja samo za Kranjsko, za druge dežele teh zapisov nisem upošteval, saj ni nijnu, da bi veljali za slovenski del dežel) -->
                <xsl:when test="tei:country and not(tei:region or tei:settlement)">
                    <xsl:attribute name="type">country</xsl:attribute>
                    <xsl:attribute name="precision">low</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Unknown placeName-corresp (person <xsl:value-of select="ancestor::tei:person/@xml:id"/>)</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </residence>
    </xsl:template>
    
</xsl:stylesheet>