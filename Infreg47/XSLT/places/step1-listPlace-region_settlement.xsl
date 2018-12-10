<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- Podlaga za ta XSLT je iz projekta Verlustliste -->
    <!-- izhodiščni Infreg47.xml -->
    <!-- iz obstoječih birth/region ustvari seznam listPlace -->
    <!-- nujno vstavi še parameter dežele -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <xsl:copy-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]"/>
                        <xsl:copy-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[2]"/>
                        <title>Seznam okrajev in krajev</title>
                    </titleStmt>
                    <xsl:copy-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt"/>
                    <xsl:copy-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPlace>
                        <xsl:for-each-group select="tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person/tei:residence" group-by="tei:country">
                            <xsl:sort select="current-grouping-key()"/>
                            <place type="country">
                                <country>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </country>
                                <idno n="{current-grouping-key()}">
                                    <xsl:for-each select="current-group()">
                                        <xsl:value-of select="../@xml:id"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </idno>
                                <xsl:for-each-group select="current-group()" group-by="tei:region">
                                    <xsl:sort select="current-grouping-key()"/>
                                    <place type="region">
                                        <region>
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </region>
                                        <idno n="{current-grouping-key()}">
                                            <xsl:for-each select="current-group()">
                                                <xsl:value-of select="../@xml:id"/>
                                                <xsl:if test="position() != last()">
                                                    <xsl:text> </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </idno>
                                        <xsl:for-each-group select="current-group()" group-by="tei:settlement">
                                            <xsl:sort select="current-grouping-key()"/>
                                            <place type="settlement">
                                                <settlement>
                                                    <xsl:value-of select="current-grouping-key()"/>
                                                </settlement>
                                                <idno n="{current-grouping-key()}">
                                                    <xsl:for-each select="current-group()">
                                                        <xsl:value-of select="../@xml:id"/>
                                                        <xsl:if test="position() != last()">
                                                            <xsl:text> </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </idno>
                                            </place>
                                        </xsl:for-each-group>
                                    </place>
                                </xsl:for-each-group>
                            </place>
                        </xsl:for-each-group>
                        <place type="country">
                            <xsl:for-each-group select="tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person/tei:residence[not(tei:country)]" group-by="tei:region">
                                <place type="region">
                                    <region>
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </region>
                                    <idno n="{current-grouping-key()}">
                                        <xsl:for-each select="current-group()">
                                            <xsl:value-of select="../@xml:id"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </idno>
                                    <xsl:for-each-group select="current-group()" group-by="tei:settlement">
                                        <xsl:sort select="current-grouping-key()"/>
                                        <place type="settlement">
                                            <settlement>
                                                <xsl:value-of select="current-grouping-key()"/>
                                            </settlement>
                                            <xsl:for-each select="current-group()">
                                                <idno type="missingCountry">
                                                    <xsl:if test="parent::tei:residence/preceding-sibling::*[1][self::tei:residence]">
                                                        <xsl:attribute name="n">
                                                            <xsl:for-each select="parent::tei:residence/preceding-sibling::*[1]">
                                                                <xsl:value-of select="."/>
                                                                <xsl:if test="position() != last()">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="parent::tei:residence/following-sibling::*[1][self::tei:residence]">
                                                        <xsl:attribute name="n">
                                                            <xsl:for-each select="parent::tei:residence/following-sibling::*[1]">
                                                                <xsl:value-of select="."/>
                                                                <xsl:if test="position() != last()">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="../@xml:id"/>
                                                </idno>
                                            </xsl:for-each>
                                        </place>
                                    </xsl:for-each-group>
                                </place>
                            </xsl:for-each-group>
                        </place>
                    </listPlace>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    
</xsl:stylesheet>