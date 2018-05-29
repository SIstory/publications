<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei html teidocx xs"
    version="2.0">
    
    <doc type="stylesheet">
        <author>Tomaž Erjavec tomaz.erjavec@ijs.si</author>
        <date>2017</date>
        <source src="http://nl.ijs.si/e-zrc/kapelski/">Elektronske znanstvenokritične izdaje slovenskega slovstva: Kapelski pasijon</source>
        <source>erzc2html.xsl</source>
    </doc>
    
    <!-- TEXT CRITICAL -->
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:handShift</desc>
    </doc>
    <xsl:template match="tei:handShift">
        <xsl:variable name="hand" select="key('id', substring-after(@new, '#'))"/>
        <span class="handShift">
            <xsl:attribute name="title">
                <xsl:call-template name="glosstext">
                    <xsl:with-param name="element" select="name(.)"/>
                </xsl:call-template>
                <xsl:text> &#x2192; </xsl:text>
                <xsl:apply-templates select="$hand" mode="explain"/>
            </xsl:attribute>
            <!--xsl:value-of select="$hand/@scribe"/-->
            <xsl:text> &#x2192;</xsl:text>
        </span>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:choice: Show one option in-line, with alternative as HTML bubble. What is where depends
            on diplomatic/critical transcription.</desc>
    </doc>
    <xsl:template match="tei:choice[tei:abbr and tei:expan]">
        <xsl:choose>
            <xsl:when test="ancestor::tei:*[@type = 'dipl' or @role = 'dipl']">
                <xsl:apply-templates select="tei:abbr">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:abbr" mode="explain"/>
                        <xsl:text> &#x2192; </xsl:text>
                        <xsl:apply-templates select="tei:expan" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:expan"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(ancestor::tei:*[@type = 'crit' or @role = 'crit'])">
                    <xsl:message>WARNING: choice has not dipl/crit marked ancestor!</xsl:message>
                </xsl:if>
                <xsl:apply-templates select="tei:expan">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:expan" mode="explain"/>
                        <xsl:text> &#x2190; </xsl:text>
                        <xsl:apply-templates select="tei:abbr" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:abbr"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:choice[tei:sic and tei:corr]">
        <xsl:choose>
            <xsl:when test="ancestor::tei:div[@type = 'dipl']">
                <xsl:apply-templates select="tei:sic">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:sic" mode="explain"/>
                        <xsl:text> &#x2192; </xsl:text>
                        <xsl:apply-templates select="tei:corr" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:corr"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:corr">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:corr" mode="explain"/>
                        <xsl:text> &#x2190; </xsl:text>
                        <xsl:apply-templates select="tei:sic" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:sic"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:choice[tei:orig and tei:reg]">
        <xsl:choose>
            <xsl:when test="ancestor::tei:div[@type = 'dipl']">
                <xsl:apply-templates select="tei:orig">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:orig" mode="explain"/>
                        <xsl:text> &#x2192; </xsl:text>
                        <xsl:apply-templates select="tei:reg" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:reg"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:reg">
                    <xsl:with-param name="title">
                        <xsl:apply-templates select="tei:reg" mode="explain"/>
                        <xsl:text> &#x2190; </xsl:text>
                        <xsl:apply-templates select="tei:orig" mode="explain"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:orig"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:choice">
        <xsl:apply-templates select="tei:*"/>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:subst</desc>
    </doc>
    <xsl:template match="tei:subst">
        <xsl:apply-templates select="tei:*"/>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:del</desc>
        <param name="title"></param>
    </doc>
    <xsl:template match="tei:del">
        <xsl:param name="title">
            <xsl:apply-templates select="self::tei:*" mode="explain"/>
        </xsl:param>
        <span class="subst" title="{$title}">
            <strike>
                <xsl:apply-templates/>
            </strike>
        </span>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process element tei:add</desc>
        <param name="title"></param>
    </doc>
    <xsl:template match="tei:add">
        <xsl:param name="title">
            <xsl:apply-templates select="self::tei:*" mode="explain"/>
        </xsl:param>
        <xsl:variable name="element">
            <span class="subst" title="{$title}">
                <xsl:apply-templates/>
            </span>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@place = 'supralinear'">
                <sup>
                    <xsl:copy-of select="$element"/>
                </sup>
            </xsl:when>
            <xsl:when test="@place = 'infralinear'">
                <sub>
                    <xsl:copy-of select="$element"/>
                </sub>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$element"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process one of Janus elements + supplied, damage</desc>
        <param name="title"></param>
    </doc>
    <xsl:template
        match="
        tei:abbr | tei:expan | tei:sic | tei:corr | tei:orig | tei:reg
        | tei:supplied | tei:damage">
        <xsl:param name="title">
            <xsl:apply-templates select="self::tei:*" mode="explain"/>
        </xsl:param>
        <span class="choice" title="{$title}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process elements tei:gap</desc>
        <param name="title"></param>
    </doc>
    <xsl:template match="tei:gap">
        <xsl:param name="title">
            <xsl:apply-templates select="self::tei:*" mode="explain"/>
        </xsl:param>
        <span class="choice" title="{$title}">
            <xsl:text>[...]</xsl:text>
        </span>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>Process elements tei:unclear</desc>
        <param name="title"></param>
    </doc>
    <xsl:template match="tei:unclear">
        <xsl:param name="title">
            <xsl:call-template name="glosstext">
                <xsl:with-param name="element" select="name(.)"/>
            </xsl:call-template>
        </xsl:param>
        <span class="unclear" title="{$title}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc></desc>
    </doc>
    <xsl:template match="tei:*" mode="explain">
        <xsl:call-template name="glosstext">
            <xsl:with-param name="element" select="name(.)"/>
        </xsl:call-template>
        <xsl:for-each
            select="@*[not(name() = 'xml:id') and not(name() = 'xml:lang') and not(name() = 'corresp')]">
            <xsl:text>; </xsl:text>
            <xsl:call-template name="glosstext">
                <xsl:with-param name="attribute" select="name(.)"/>
            </xsl:call-template>
            <xsl:text>: </xsl:text>
            <xsl:choose>
                <xsl:when test="starts-with(., '#')">
                    <xsl:value-of select="normalize-space(key('id', substring-after(., '#')))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="glosstext">
                        <xsl:with-param name="attribute" select="name(.)"/>
                        <xsl:with-param name="value" select="normalize-space(.)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!-- Output content only if in header of it's a desc -->
        <xsl:variable name="content">
            <xsl:choose>
                <xsl:when test="ancestor::tei:teiHeader">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:when>
                <xsl:when test="tei:desc">
                    <xsl:value-of select="normalize-space(tei:desc)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="normalize-space($content)">
            <!-- ... and ancestor-of-self::tei:*[@xml:lang][1][@xml:lang=$lang]" -->
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$content"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc> Output gloss text from localisation file</desc>
        <param name="element"></param>
        <param name="attribute"></param>
        <param name="value"></param>
        <param name="language"></param>
    </doc>
    <xsl:template name="glosstext">
        <xsl:param name="element"/>
        <xsl:param name="attribute"/>
        <xsl:param name="value"/>
        <xsl:param name="language" select="$documentationLanguage"/>
        <xsl:variable name="ident">
            <xsl:choose>
                <xsl:when test="$value">
                    <xsl:value-of select="$value"/>
                </xsl:when>
                <xsl:when test="$attribute">
                    <xsl:value-of select="$attribute"/>
                </xsl:when>
                <xsl:when test="$element">
                    <xsl:value-of select="$element"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="specs">
            <xsl:choose>
                <xsl:when test="$value">
                    <!--xsl:message>
	    <xsl:value-of select="concat('INFO: value [', $value, ']')"/>
	  </xsl:message-->
                    <xsl:choose>
                        <xsl:when
                            test="
                            doc($localisation-file)//attDef[@ident = $attribute]//
                            tei:valItem[@ident = $value]">
                            <xsl:copy-of
                                select="
                                doc($localisation-file)//attDef[@ident = $attribute]//
                                tei:valItem[@ident = $value]"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="doc($localisation-file)//tei:valItem[@ident = $ident]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$attribute">
                    <!--xsl:message>
	    <xsl:value-of select="concat('INFO: attribute [', $attribute, ']')"/>
	  </xsl:message-->
                    <xsl:copy-of select="doc($localisation-file)//tei:attDef[@ident = $ident]"/>
                </xsl:when>
                <xsl:when test="$element">
                    <!--xsl:message>
	    <xsl:value-of select="concat('INFO: element [', $element, ']')"/>
	  </xsl:message-->
                    <xsl:copy-of select="doc($localisation-file)//tei:elementSpec[@ident = $ident]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        <xsl:value-of select="'ERROR: glosstext what?'"/>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$specs/tei:*/tei:gloss[@xml:lang = $language]">
                <xsl:value-of select="$specs/tei:*/tei:gloss[@xml:lang = $language]"/>
            </xsl:when>
            <xsl:when test="not($specs) and not($value)">
                <xsl:if test="$language != 'en'">
                    <xsl:message>
                        <xsl:value-of
                            select="
                            concat('ERROR: cant find ', $language, ' gloss for ',
                            'id', $ident, 'tei:', $element, ' @', $attribute, ' = ', $value)"
                        />
                    </xsl:message>
                </xsl:if>
                <xsl:value-of select="$ident"/>
            </xsl:when>
            <xsl:when test="matches($ident, '^\d+$')">
                <xsl:value-of select="$ident"/>
            </xsl:when>
            <xsl:when test="matches($ident, '^#')">
                <xsl:value-of select="$ident"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:value-of select="concat('WARNING: cant find @ident for [', $ident, ']')"/>
                </xsl:message>
                <xsl:value-of select="$ident"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>