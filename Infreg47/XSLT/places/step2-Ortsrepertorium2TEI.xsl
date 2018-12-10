<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- Ortsrepertorije za leto 1910 iz https://github.com/SIstory/Ortsrepertorium kodiram v skladu s TEI -->
    <!-- OBVEZNO najprej izvorni datoteki dodaj xml:id atribute za administrativne enote krajev -->
    <!-- Dodaj utrezne parametre -->
    <xsl:param name="subtitle">Koroška 1910: deli današnje Slovenije</xsl:param>
    <xsl:param name="guthubFile">https://github.com/SIstory/Ortsrepertorium/blob/master/year1910/Carinthia/Carinthia-1910-deu.xml</xsl:param>
    <xsl:param name="githubCommit">https://github.com/SIstory/Ortsrepertorium/commit/394d9223f5a3abf9c41822b3e661373bc8ae5059</xsl:param>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="root">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Krajevni repertorij</title>
                        <title>
                            <xsl:value-of select="$subtitle"/>
                        </title>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>Inštitut za novejšo zgodovino</publisher>
                        <distributor>Raziskovalna infrastruktura slovenskega zgodovinopisja</distributor>
                        <distributor>DARIAH-SI</distributor>
                        <pubPlace>https://github.com/SIstory/Ortsrepertorium</pubPlace>
                        <availability status="free">
                            <licence>http://creativecommons.org/licenses/by/4.0/</licence>
                            <p xml:lang="en">This work is licensed under the <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                Attribution 4.0 International License</ref>.</p>
                            <p xml:lang="sl">To delo je ponujeno pod <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                                Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
                        </availability>
                        <date when="{current-date()}"/>
                        <idno type="github" subtype="commit">
                            <xsl:value-of select="$githubCommit"/>
                        </idno>
                    </publicationStmt>
                    <sourceDesc>
                        <p>
                            <ref target="{$guthubFile}">GitHub</ref>
                        </p>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <classDecl>
                        <taxonomy>
                            <desc>Administrativne enote v avstrijski polovici habsburške monarhije</desc>
                            <category xml:id="ad.land">
                                <catDesc xml:lang="en">Country</catDesc>
                                <catDesc xml:lang="sl">Dežela</catDesc>
                                <catDesc xml:lang="de">Land</catDesc>
                                <category xml:id="ad.stadt">
                                    <catDesc xml:lang="en">Statutory city</catDesc>
                                    <catDesc xml:lang="sl">Mesto z lastnim statutom</catDesc>
                                    <catDesc xml:lang="de">Stadt mit eigenem Statut</catDesc>
                                </category>
                                <category xml:id="ad.bezirk">
                                    <catDesc xml:lang="en">Administrative district</catDesc>
                                    <catDesc xml:lang="sl">Politični okraj</catDesc>
                                    <catDesc xml:lang="de">Politischer Bezirk</catDesc>
                                    <category xml:id="ad.gerichtsbezirk">
                                        <catDesc xml:lang="en">Judicial district</catDesc>
                                        <catDesc xml:lang="sl">Sodni okraj</catDesc>
                                        <catDesc xml:lang="de">Gerichtsbezirk</catDesc>
                                        <category xml:id="ad.gemeinde">
                                            <catDesc xml:lang="en">Municipality</catDesc>
                                            <catDesc xml:lang="sl">Občina</catDesc>
                                            <catDesc xml:lang="de">Gemeinde</catDesc>
                                            <category xml:id="ad.ort">
                                                <catDesc xml:lang="en">Place</catDesc>
                                                <catDesc xml:lang="sl">Kraj</catDesc>
                                                <catDesc xml:lang="de">Ort</catDesc>
                                                <category xml:id="ad.teil">
                                                    <catDesc xml:lang="en">Local district</catDesc>
                                                    <catDesc xml:lang="sl">Krajevni del</catDesc>
                                                    <catDesc xml:lang="de">Ortsbestandteil</catDesc>
                                                </category>
                                            </category>
                                        </category>
                                    </category>
                                </category>
                            </category>
                        </taxonomy>
                    </classDecl>
                </encodingDesc>
            </teiHeader>
            <text>
                <body>
                    <listPlace>
                        <xsl:for-each select="polBezirke/polBezirk | polOkraji/polBezirk | polOkraji/polOkraj">
                            <place ana="#ad.bezirk">
                                <xsl:if test="@xml:id">
                                    <xsl:attribute name="xml:id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates select="placeName"/>
                                <xsl:apply-templates select="geo"/>
                                <xsl:for-each select="gerichtsBezirke/gerichtsBezirk | sodniOkraji/gerichtsBezirk | sodniOkraji/sodniOkraj">
                                    <place ana="#ad.gerichtsbezirk">
                                        <xsl:if test="@xml:id">
                                            <xsl:attribute name="xml:id">
                                                <xsl:value-of select="@xml:id"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="@n">
                                            <xsl:attribute name="n">
                                                <xsl:value-of select="@n"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:apply-templates select="placeName"/>
                                        <xsl:apply-templates select="geo"/>
                                        <xsl:for-each select="gemeinden/gemeinde | obcine/gemeinde | obcine/obcina">
                                            <place ana="#ad.gemeinde" >
                                                <xsl:if test="@xml:id">
                                                    <xsl:attribute name="xml:id">
                                                        <xsl:value-of select="@xml:id"/>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="@n">
                                                    <xsl:attribute name="n">
                                                        <xsl:value-of select="@n"/>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:apply-templates select="placeName"/>
                                                <xsl:apply-templates select="geo"/>
                                                <xsl:for-each select="orte/ort | kraji/ort | kraji/kraj">
                                                    <place ana="#ad.ort">
                                                        <xsl:if test="@xml:id">
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="@xml:id"/>
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:if test="@n">
                                                            <xsl:attribute name="n">
                                                                <xsl:value-of select="@n"/>
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:apply-templates select="placeName"/>
                                                        <xsl:apply-templates select="geo"/>
                                                        <xsl:for-each select="teile/teil | deli/teil | deli/del">
                                                            <place ana="#ad.teil">
                                                                <xsl:if test="@xml:id">
                                                                    <xsl:attribute name="xml:id">
                                                                        <xsl:value-of select="@xml:id"/>
                                                                    </xsl:attribute>
                                                                </xsl:if>
                                                                <xsl:apply-templates select="placeName"/>
                                                                <xsl:apply-templates select="geo"/>
                                                            </place>
                                                        </xsl:for-each>
                                                    </place>
                                                </xsl:for-each>
                                            </place>
                                        </xsl:for-each>
                                    </place>
                                </xsl:for-each>
                            </place>
                        </xsl:for-each>
                    </listPlace>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="placeName">
        <placeName xml:lang="{@lang}">
            <xsl:if test="@key">
                <xsl:attribute name="key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
        </placeName>
    </xsl:template>
    
    <xsl:template match="geo">
        <location>
            <geo>
                <xsl:value-of select="."/>
            </geo>
        </location>
    </xsl:template>
    
</xsl:stylesheet>