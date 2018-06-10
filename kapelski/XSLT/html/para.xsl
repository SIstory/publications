<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:param name="path-general">../../../</xsl:param>
    
    <!-- S tem lahko odstranim procesiranje opomb: v originalnem pararelnem prikazu namreč tudi niso procesirane! -->
    <xsl:param name="processNotes">false</xsl:param>
    
    <xsl:param name="firstPB">0r</xsl:param>
    <xsl:param name="firstMilestone">1</xsl:param>
    
    <xsl:template match="/">
        <!-- type = prikaz po straneh (page) ali prikaz po vsebinskih sklopih (section) -->
        <xsl:variable name="type" select="(ixsl:query-params()?type)"/>
        <!-- mode: prikaz glede na način: vse različne kombinacije facs, dipl, crit -->
        <xsl:variable name="mode" select="(ixsl:query-params()?mode)"/>
        <!-- prikaz posamezne strani (iz pb/@n, povezava pa seveda na @xml:id) -->
        <xsl:variable name="page" select="(ixsl:query-params()?page)"/>
        <!-- prikaz posameznega vsebinskega sklopa (iz milestone/@n se ven poberejo številke) -->
        <xsl:variable name="section" select="(ixsl:query-params()?section)"/>
        <!-- prelomi vrstic: linebreak (boolean: 0 ali 1) -->
        <xsl:variable name="lb" select="(ixsl:query-params()?lb)"/>
        
        <xsl:variable name="pages">
            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@xml:id='crit']/tei:div[@type='crit']//tei:pb">
                <page><xsl:value-of select="@n"/></page>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="previousPage" select="$pages/page[.=$page]/preceding-sibling::page[1]"/>
        <xsl:variable name="nextPage" select="$pages/page[.=$page]/following-sibling::page[1]"/>
        <xsl:variable name="sections">
            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@xml:id='crit']/tei:div[@type='crit']//tei:milestone">
                <section><xsl:value-of select="@n"/></section>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="previousSection" select="$sections/section[.=$section]/preceding-sibling::section[1]"/>
        <xsl:variable name="nextSection" select="$sections/section[.=$section]/following-sibling::section[1]"/>
        
        <xsl:result-document href="#para" method="ixsl:replace-content">
            <p>Vzporedni prikazi faksimilov ter diplomatičnega in kritičnega prepisa:</p>
            <p class="show-for-small-only">Na malih zaslonih vzporednih prikazi ne delujejo. En prikaz je pod drugim.</p>
            <!-- V prvi vrstici
                 - v prvem (levem) stolpcu najprej izberemo tip prikazovanja (strani ali vsebinske sklope), -->
            <div class="row">
                <div class="medium-4 columns">
                    <div class="dropdown">
                        <button class="dropdown button">
                            <xsl:choose>
                                <xsl:when test="$type">
                                    <xsl:value-of select="concat('Vrsta prikaza ', if ($type='page') then '(strani)' else '(sklopi)')"/>
                                </xsl:when>
                                <xsl:otherwise>Izberi vrsto prikaza</xsl:otherwise>
                            </xsl:choose>
                        </button>
                        <div class="dropdown-content">
                            <a href="para.html?type=page">
                                <xsl:if test="$type = 'page'">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if>
                                <xsl:text>Po straneh</xsl:text>
                            </a>
                            <!-- Ker je samo en možen način prikaza vsebinskih sklopov (dipl-crit), ga takoj prikaže (tudi privzeto prkaže prelom vrstic) -->
                            <a href="para.html?type=section&amp;mode=dipl-crit&amp;section={$firstMilestone}&amp;lb={if ($lb) then $lb else '1'}">
                                <xsl:if test="$type = 'section'">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if>
                                <xsl:text>Po vsebinskih sklopih</xsl:text>
                            </a>
                        </div>
                    </div>
                </div>
                <!-- V prvi vrstici:
                      - v drugem (srednjem) stolpcu nato glede na prejšnjo izbiro tipa (strani ali vsebinski sklopi)
                        izberemo vrsto (mode) prikazovanja (različne kombinacije faksimilov in diplomatičnega in kritičnega prepisa) -->
                <div class="medium-4 columns">
                    <xsl:if test="$type='page'">
                        <div class="dropdown">
                            <button class="secondary dropdown button">
                                <xsl:if test="$mode">
                                    <xsl:attribute name="style">background: #8e130b;</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="$mode">
                                        <xsl:value-of select="concat('Način vzporednega prikaza (',$mode,')')"/>
                                    </xsl:when>
                                    <xsl:otherwise>Izberi način vzporednega prikaza</xsl:otherwise>
                                </xsl:choose>
                            </button>
                            <div class="dropdown-content">
                                <a href="para.html?type=page&amp;mode=facs-dipl&amp;page={if ($page) then $page else $firstPB}&amp;lb={if ($lb) then $lb else '1'}">
                                    <xsl:if test="$mode = 'facs-dipl'">
                                        <xsl:attribute name="class">active</xsl:attribute>
                                    </xsl:if>
                                    <xsl:text>Faksimile / Diplomatični prepis</xsl:text>
                                </a>
                                <a href="para.html?type=page&amp;mode=facs-crit&amp;page={if ($page) then $page else $firstPB}&amp;lb={if ($lb) then $lb else '1'}">
                                    <xsl:if test="$mode = 'facs-crit'">
                                        <xsl:attribute name="class">active</xsl:attribute>
                                    </xsl:if>
                                    <xsl:text>Faksimile / Kritični prepis</xsl:text>
                                </a>
                                <a href="para.html?type=page&amp;mode=dipl-crit&amp;page={if ($page) then $page else $firstPB}&amp;lb={if ($lb) then $lb else '1'}">
                                    <xsl:if test="$mode = 'dipl-crit'">
                                        <xsl:attribute name="class">active</xsl:attribute>
                                    </xsl:if>
                                    <xsl:text>Diplomatični / Kritični prepis</xsl:text>
                                </a>
                                <a href="para.html?type=page&amp;mode=facs-dipl-crit&amp;page={if ($page) then $page else $firstPB}&amp;lb={if ($lb) then $lb else '1'}">
                                    <xsl:if test="$mode = 'facs-dipl-crit'">
                                        <xsl:attribute name="class">active</xsl:attribute>
                                    </xsl:if>
                                    <xsl:text>Faksimile / Diplomatični / Kritični prepis</xsl:text>
                                </a>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:if test="$type='section'">
                        <a class="button" href="para.html?type=section&amp;mode=dipl-crit&amp;section={if ($section) then $section else $firstMilestone}&amp;lb={if ($lb) then $lb else '1'}">
                            <xsl:text>Diplomatični / Kritični prepis</xsl:text>
                        </a>
                    </xsl:if>
                </div>
                <!-- V prvi vrstici: 
                     - v tretjem (najbolj desnem) stolpcu) je vklop ali izklop parametra za prikaz preloma vrstic -->
                <div class="medium-4 columns">
                    <xsl:if test="$mode">
                        <dir class="row">
                            <div class="small-6 columns text-right">
                                <p>Prelom vrstice:</p>
                            </div>
                            <div class="small-6 columns">
                                <div class="secondary button-group">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;{if ($page) then ('page='||$page) else ('section='||$section)}&amp;lb=1">
                                        <xsl:if test="$lb='1'">
                                            <xsl:attribute name="style">background: #8e130b;</xsl:attribute>
                                        </xsl:if>
                                        <xsl:text>Da</xsl:text>
                                    </a>
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;{if ($page) then ('page='||$page) else ('section='||$section)}&amp;lb=0">
                                        <xsl:if test="$lb='0'">
                                            <xsl:attribute name="style">background: #8e130b;</xsl:attribute>
                                        </xsl:if>
                                        <xsl:text>Ne</xsl:text>
                                    </a>
                                </div>
                            </div>
                        </dir>
                    </xsl:if>
                </div>
            </div>
            
            <!-- procesiramo glavne vsebine faksimilov ter diplomatičnega in kritičnega prikaza -->
            <xsl:if test="$type and $mode and ($page or $section)">
                <!-- Različni prikazi strani -->
                <xsl:if test="$type='page'">
                    <!-- spodnje štiri variable pretvorijo številke strani v pb/@xml:id za diplomatičen in kritičen prepis -->
                    <xsl:variable name="page-start-dipl">
                        <xsl:call-template name="page-start">
                            <xsl:with-param name="page" select="$page"/>
                            <xsl:with-param name="content-type">dipl</xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="page-end-dipl">
                        <xsl:call-template name="page-end">
                            <xsl:with-param name="nextPage" select="$nextPage"/>
                            <xsl:with-param name="content-type">dipl</xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="page-start-crit">
                        <xsl:call-template name="page-start">
                            <xsl:with-param name="page" select="$page"/>
                            <xsl:with-param name="content-type">crit</xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="page-end-crit">
                        <xsl:call-template name="page-end">
                            <xsl:with-param name="nextPage" select="$nextPage"/>
                            <xsl:with-param name="content-type">crit</xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <!-- Pred glavno vsebino na vrhu najprej prikažemo vrstico za premikanje naprej in nazaj po straneh (isto kot spodaj):
                         skupaj z možnostjo vpisa številke strani
                    -->
                    <div class="row">
                        <div class="small-3 columns">
                            <p>
                                <xsl:if test="$previousPage != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;page={$previousPage}&amp;lb={$lb}">
                                        <xsl:value-of select="concat($previousPage,' &lt;&lt;')"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                        <div class="small-6 columns">
                            <form action="para.html" autocomplete="off">
                                <div class="row collapse">
                                    <div class="small-4 columns text-right">
                                        <button class="button" type="submit">stran</button>
                                    </div>
                                    <div class="small-8 columns text-left">
                                        <input type="hidden" name="type" value="{$type}"/>
                                        <input type="hidden" name="mode" value="{$mode}"/>
                                        <input type="text" name="page" list="pages" placeholder="{$page}"/>
                                        <input type="hidden" name="lb" value="{$lb}"/>
                                    </div>
                                </div>
                            </form>
                            <!-- autocomplete list -->
                            <datalist id="pages">
                                <xsl:for-each select="$pages/page">
                                    <option>
                                        <xsl:value-of select="."/>
                                    </option>
                                </xsl:for-each>
                            </datalist>
                        </div>
                        <div class="small-3 columns text-right">
                            <p>
                                <xsl:if test="$nextPage != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;page={$nextPage}&amp;lb={$lb}">
                                        <xsl:value-of select="concat('&gt;&gt; ',$nextPage)"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                    </div>
                    <!-- začetek procesiranja vseh štirih možnih pogledov -->
                    <xsl:if test="$mode='facs-dipl'">
                        <div class="row border-content">
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="pannable-image">
                                    <xsl:with-param name="page" select="$page"/>
                                </xsl:call-template>
                            </div>
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-dipl"/>
                                    <xsl:with-param name="content-end" select="$page-end-dipl"/>
                                    <xsl:with-param name="content-type">dipl</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:if test="$mode='facs-crit'">
                        <div class="row border-content">
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="pannable-image">
                                    <xsl:with-param name="page" select="$page"/>
                                </xsl:call-template>
                            </div>
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-crit"/>
                                    <xsl:with-param name="content-end" select="$page-end-crit"/>
                                    <xsl:with-param name="content-type">crit</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:if test="$mode='dipl-crit'">
                        <div class="row border-content">
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-dipl"/>
                                    <xsl:with-param name="content-end" select="$page-end-dipl"/>
                                    <xsl:with-param name="content-type">dipl</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-crit"/>
                                    <xsl:with-param name="content-end" select="$page-end-crit"/>
                                    <xsl:with-param name="content-type">crit</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:if test="$mode='facs-dipl-crit'">
                        <div class="row border-content">
                            <div class="medium-4 columns border-content-inner">
                                <xsl:call-template name="pannable-image">
                                    <xsl:with-param name="page" select="$page"/>
                                </xsl:call-template>
                            </div>
                            <div class="medium-4 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-dipl"/>
                                    <xsl:with-param name="content-end" select="$page-end-dipl"/>
                                    <xsl:with-param name="content-type">dipl</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                            <div class="medium-4 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$page-start-crit"/>
                                    <xsl:with-param name="content-end" select="$page-end-crit"/>
                                    <xsl:with-param name="content-type">crit</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </xsl:if>
                    <!-- prikažemo še povezavo na to stran v okviru prikaza celotne vsebine diplomatičnega ali kritičnega prepisa -->
                    <div class="row show-for-medium">
                        <div class="medium-{if ($mode='facs-dipl-crit') then '4' else '6'} columns text-center">
                            <xsl:choose>
                                <xsl:when test="tokenize($mode,'-')[1] = 'facs'">
                                    <p></p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a class="button" href="dipl.html#{$page-start-dipl}">Celotno besedilo</a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="medium-{if ($mode='facs-dipl-crit') then '4' else '6'} columns text-center">
                            <xsl:if test="tokenize($mode,'-')[2] = 'dipl'">
                                <a class="button" href="dipl.html#{$page-start-dipl}">Celotno besedilo</a>
                            </xsl:if>
                            <xsl:if test="tokenize($mode,'-')[2] = 'crit'">
                                <a class="button" href="crit.html#{$page-start-crit}">Celotno besedilo</a>
                            </xsl:if>
                        </div>
                        <xsl:if test="$mode='facs-dipl-crit'">
                            <div class="medium-4 columns text-center">
                                <a class="button" href="crit.html#{$page-start-crit}">Celotno besedilo</a>
                            </div>
                        </xsl:if>
                    </div>
                    <!-- na koncu nato pod glavno vsebino prikažemo vrstico za premikanje naprej in nazaj po straneh -->
                    <div class="row">
                        <div class="small-6 columns text-center">
                            <p>
                                <xsl:if test="$previousPage != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;page={$previousPage}&amp;lb={$lb}">
                                        <xsl:value-of select="concat($previousPage,' &lt;&lt;')"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                        <div class="small-6 columns text-center">
                            <p>
                                <xsl:if test="$nextPage != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;page={$nextPage}&amp;lb={$lb}">
                                        <xsl:value-of select="concat('&gt;&gt; ',$nextPage)"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                    </div>
                </xsl:if>
                <!-- Procesiranje prikaza vsebinskih sklopov 
                     (kazalo vsebine teh sklopov se procesira in prikaže posebej - vzrok: skupno procesiranje zahteva preveč časa) -->
                <xsl:if test="$type='section' and $mode != 'toc'">
                    <!-- Pred glavno vsebino na vrhu najprej prikažemo vrstico za premikanje naprej in nazaj po vsebinskih sklopihizbora (spodaj jih nisem dal):
                         skupaj z možnostjo prikaza navigacije po strukturi vsebinskih sklopov
                    -->
                    <div class="row">
                        <div class="small-3 columns">
                            <p>
                                <xsl:if test="$previousSection != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;section={$previousSection}&amp;lb={$lb}">
                                        <xsl:value-of select="concat($previousSection,' &lt;&lt;')"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                        <div class="small-3 columns text-center">
                            <h3>
                                <xsl:text>Sklop </xsl:text>
                                <xsl:value-of select="$section"/>
                            </h3>
                        </div>
                        <div class="small-3 columns text-center">
                            <!-- odstranim checkbox gumb, ki sem ga prej uporabljal pri prikazovanje kazala vsebine vsebinskih sklopov znotraj prikaza vsebine posameznih sklopov -->
                            <!--<input type="checkbox" id="treeview" value="treeview-container"/>
                            <label for="treeview">Kazalo</label>-->
                            <a class="button" href="para.html?type={$type}&amp;mode=toc&amp;section={$section}&amp;lb={$lb}">Kazalo</a>
                        </div>
                        <div class="small-3 columns text-right">
                            <p>
                                <xsl:if test="$nextSection != ''">
                                    <a class="button" href="para.html?type={$type}&amp;mode={$mode}&amp;section={$nextSection}&amp;lb={$lb}">
                                        <xsl:value-of select="concat('&gt;&gt; ',$nextSection)"/>
                                    </a>
                                </xsl:if>
                            </p>
                        </div>
                    </div>
                    <!-- Trenutno za section samo en mode: dipl-crit -->
                    <xsl:if test="$mode='dipl-crit'">
                        <!-- iz @n vrednosti rekonstruriram @xml:id (za milestone) -->
                        <xsl:variable name="section-start-dipl">
                            <xsl:call-template name="section-start">
                                <xsl:with-param name="section" select="$section"/>
                                <xsl:with-param name="content-type">dipl</xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="section-end-dipl">
                            <xsl:call-template name="section-end">
                                <xsl:with-param name="nextSection" select="$nextSection"/>
                                <xsl:with-param name="content-type">dipl</xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="section-start-crit">
                            <xsl:call-template name="section-start">
                                <xsl:with-param name="section" select="$section"/>
                                <xsl:with-param name="content-type">crit</xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="section-end-crit">
                            <xsl:call-template name="section-end">
                                <xsl:with-param name="nextSection" select="$nextSection"/>
                                <xsl:with-param name="content-type">crit</xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <div class="row border-content">
                            <!-- dipl -->
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$section-start-dipl"/>
                                    <xsl:with-param name="content-end" select="$section-end-dipl"/>
                                    <xsl:with-param name="content-type">dipl</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                            <!-- crit -->
                            <div class="medium-6 columns border-content-inner">
                                <xsl:call-template name="process-content">
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$section-start-crit"/>
                                    <xsl:with-param name="content-end" select="$section-end-crit"/>
                                    <xsl:with-param name="content-type">crit</xsl:with-param>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:call-template>
                            </div>
                        </div>
                        <!-- prikažemo še povezavo na to sklop v okviru prikaza celotne vsebine diplomatičnega ali kritičnega prepisa -->
                        <div class="row show-for-medium">
                            <div class="medium-6 columns text-center">
                                <a class="button" href="dipl.html#{$section-start-dipl}">Celotno besedilo</a>
                            </div>
                            <div class="medium-6 columns text-center">
                                <a class="button" href="crit.html#{$section-start-crit}">Celotno besedilo</a>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:if>
                <!-- ločeno procesiranje kazala vsebine vsebinskih sklopov -->
                <xsl:if test="$type='section' and $mode='toc'">
                    <!-- kazalo vsebine sklopov: (Če bi ga hotel prikazati s checkbox, bi ga moral prej skriti z atributom  hidden="hidden" -->
                    <div class="row" id="treeview-container">
                        <xsl:variable name="milestones">
                            <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@xml:id='crit']/tei:div[@type='crit']//tei:milestone">
                                <milestone n="{@n}" n1="{tokenize(@n,'\.')[1]}" n2="{tokenize(@n,'\.')[2]}" n3="{tokenize(@n,'\.')[3]}">
                                    <xsl:variable name="besedilo">
                                        <xsl:apply-templates select="following-sibling::*[1]" mode="besedilo"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:apply-templates select="following-sibling::*[2]" mode="besedilo"/>
                                    </xsl:variable>
                                    <xsl:value-of select="substring(normalize-space($besedilo),1,50)"/>
                                    <xsl:text> [...]</xsl:text>
                                </milestone>
                            </xsl:for-each>
                        </xsl:variable>
                        <ul>
                            <li>
                                <a href="para.html?type={$type}&amp;mode=dipl-crit&amp;section={$milestones/milestone[1]/@n}&amp;lb={$lb}">
                                    <xsl:if test="$milestones/milestone[1]/@n = $section">
                                        <xsl:attribute name="class">jstree-clicked</xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="concat('[',$milestones/milestone[1]/@n,']: ')"/>
                                    <xsl:value-of select="$milestones/milestone[1]"/>
                                </a>
                                <ul>
                                    <xsl:for-each-group select="$milestones/milestone[string-length(@n2) gt 0]" group-by="@n1">
                                        <li>
                                            <a href="para.html?type={$type}&amp;mode=dipl-crit&amp;section={@n}&amp;lb={$lb}">
                                                <xsl:if test="@n = $section">
                                                    <xsl:attribute name="class">jstree-clicked</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="concat('[',current-group()[string-length(@n3) = 0]/@n,']: ')"/>
                                                <xsl:value-of select="current-group()[string-length(@n3) = 0]"/>
                                            </a>
                                            <ul>
                                                <xsl:for-each-group select="current-group()[string-length(@n3) gt 0]" group-by="@n2">
                                                    <li>
                                                        <a href="para.html?type={$type}&amp;mode=dipl-crit&amp;section={@n}&amp;lb={$lb}">
                                                            <xsl:if test="@n = $section">
                                                                <xsl:attribute name="class">jstree-clicked</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:value-of select="concat('[',current-group()[1]/@n,']: ',current-group()[1])"/>
                                                        </a>
                                                        <xsl:if test="current-group()[2]">
                                                            <ul>
                                                                <xsl:for-each select="current-group()[position() != 1]">
                                                                    <li>
                                                                        <a href="para.html?type={$type}&amp;mode=dipl-crit&amp;section={@n}&amp;lb={$lb}">
                                                                            <xsl:if test="@n = $section">
                                                                                <xsl:attribute name="class">jstree-clicked</xsl:attribute>
                                                                            </xsl:if>
                                                                            <xsl:value-of select="concat('[',@n,']: ',.)"/>
                                                                        </a>
                                                                    </li>
                                                                </xsl:for-each>
                                                            </ul>
                                                        </xsl:if>
                                                    </li>
                                                </xsl:for-each-group>
                                            </ul>
                                        </li>
                                    </xsl:for-each-group>
                                </ul>
                            </li>
                        </ul>
                        <script type="text/javascript">
                            $('#treeview-container').jstree().bind("select_node.jstree", function (e, data) {
                            var href = data.node.a_attr.href;
                            document.location.href = href;
                            });
                        </script>
                    </div>
                </xsl:if>
            </xsl:if>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Ker sem odstranil procesiranje kazala vsebine vsebinskih sklopov znotraj glavnega prikaza posameznih sklopov, tega več ne rabim -->
    <!--<xsl:template match="input[@type='checkbox'][@id='treeview']" mode="ixsl:onclick">
        <xsl:variable name="this" select="."/>
        <xsl:for-each select="//div[@id=$this/@value]">
            <ixsl:set-style name="display" select="if (ixsl:get($this,'checked')) then 'block' else 'none'"/>
        </xsl:for-each>
    </xsl:template>-->
    
    <xsl:template name="page-start">
        <xsl:param name="page"/>
        <xsl:param name="content-type"/>
        <xsl:choose>
            <xsl:when test="$page='0r'">
                <xsl:value-of select="concat($content-type,'.pb.00',$page)"/>
            </xsl:when>
            <xsl:when test="matches($page,'[0-9]{3}')">
                <xsl:value-of select="concat($content-type,'.pb.',$page)"/>
            </xsl:when>
            <xsl:when test="matches($page,'[0-9]{2}')">
                <xsl:value-of select="concat($content-type,'.pb.0',$page)"/>
            </xsl:when>
            <xsl:when test="matches($page,'[0-9]')">
                <xsl:value-of select="concat($content-type,'.pb.00',$page)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="page-end">
        <xsl:param name="nextPage"/>
        <xsl:param name="content-type"/>
        <xsl:if test="$nextPage != ''">
            <xsl:choose>
                <xsl:when test="matches($nextPage,'[0-9]{3}')">
                    <xsl:value-of select="concat($content-type,'.pb.',$nextPage)"/>
                </xsl:when>
                <xsl:when test="matches($nextPage,'[0-9]{2}')">
                    <xsl:value-of select="concat($content-type,'.pb.0',$nextPage)"/>
                </xsl:when>
                <xsl:when test="matches($nextPage,'[0-9]')">
                    <xsl:value-of select="concat($content-type,'.pb.00',$nextPage)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="section-start">
        <xsl:param name="section"/>
        <xsl:param name="content-type"/>
        <xsl:choose>
            <xsl:when test="matches($section,'[0-9]+\.[0-9]+\.[0-9]+')">
                <xsl:value-of select="concat($content-type,'.',tokenize($section,'\.')[1],'.',tokenize($section,'\.')[2],'.milestone.',tokenize($section,'\.')[3])"/>
            </xsl:when>
            <xsl:when test="matches($section,'[0-9]+\.[0-9]+')">
                <xsl:value-of select="concat($content-type,'.',tokenize($section,'\.')[1],'.milestone.',tokenize($section,'\.')[2])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($content-type,'.milestone.',$section)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="section-end">
        <xsl:param name="nextSection"/>
        <xsl:param name="content-type"/>
        <xsl:if test="$nextSection != ''">
            <xsl:choose>
                <xsl:when test="matches($nextSection,'[0-9]+\.[0-9]+\.[0-9]+')">
                    <xsl:value-of select="concat($content-type,'.',tokenize($nextSection,'\.')[1],'.',tokenize($nextSection,'\.')[2],'.milestone.',tokenize($nextSection,'\.')[3])"/>
                </xsl:when>
                <xsl:when test="matches($nextSection,'[0-9]+\.[0-9]+')">
                    <xsl:value-of select="concat($content-type,'.',tokenize($nextSection,'\.')[1],'.milestone.',tokenize($nextSection,'\.')[2])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($content-type,'.milestone.',$nextSection)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="pannable-image">
        <xsl:param name="page"/>
        <xsl:variable name="image-name">
            <xsl:choose>
                <xsl:when test="$page='0r'">
                    <xsl:value-of select="concat('00',$page)"/>
                </xsl:when>
                <xsl:when test="matches($page,'[0-9]{3}')">
                    <xsl:value-of select="$page"/>
                </xsl:when>
                <xsl:when test="matches($page,'[0-9]{2}')">
                    <xsl:value-of select="concat('0',$page)"/>
                </xsl:when>
                <xsl:when test="matches($page,'[0-9]')">
                    <xsl:value-of select="concat('00',$page)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <img id="image" src="http://nl.ijs.si/e-zrc/kapelski/facs/orig/{$image-name}.jpg"/>
        <!--<img id="image" src="facs/orig/{$image-name}.jpg"/>-->
        <script>
            var image = document.getElementById('image');
            var viewer = new Viewer(image, {
              inline: true,
              navbar: false,
              title: false,
              toolbar: false
            });
        </script>
    </xsl:template>
    
    <xsl:template name="process-content">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:variable name="content">
            <!-- Za $content-type dipl in crit -->
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div[@xml:id=$content-type]/tei:div[@type=$content-type]/*">
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
        </xsl:variable>
        <!-- Vsebina -->
        <xsl:choose>
            <xsl:when test="$type='page' and string-length($content) = 0">
                <div class="warning callout">
                    <h5>Stran ne obstaja!</h5>
                    <p>Izbrana stran ne obstaja. Iz spustnega seznama strani izberite obstoječo stran.</p>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$content"/>
            </xsl:otherwise>
        </xsl:choose>
            
        <!-- Opombe -->
        <xsl:if test="$processNotes='true'">
            <xsl:variable name="notes">
                <xsl:if test="$type='page'">
                    <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@xml:id=$content-type]/tei:div[@type=$content-type]//tei:note[if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="$type='section'">
                    <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@xml:id=$content-type]/tei:div[@type=$content-type]//tei:note[if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
            <xsl:if test="$notes/tei:note">
                <br/>
                <div class="notes">
                    <div class="noteHeading">Opombe</div>
                    <xsl:for-each select="$notes/tei:note">
                        <div class="note" id="note.{@n}">
                            <p><a class="link_return" title="Pojdi nazaj k besedilu" href="#note.{@n}_return"><sup><xsl:value-of select="@n"/>.</sup></a> <span class="noteBody">
                                <xsl:if test="not(tei:p)">
                                    <xsl:apply-templates>
                                        <xsl:with-param name="type" select="$type"/>
                                        <xsl:with-param name="mode" select="$mode"/>
                                        <xsl:with-param name="content-start" select="$content-start"/>
                                        <xsl:with-param name="content-end" select="$content-end"/>
                                        <xsl:with-param name="content-type" select="$content-type"/>
                                        <xsl:with-param name="lb" select="$lb"/>
                                    </xsl:apply-templates>
                                </xsl:if>
                            </span></p>
                            <xsl:if test="tei:p">
                                <xsl:apply-templates>
                                    <xsl:with-param name="process">true</xsl:with-param>
                                </xsl:apply-templates>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- pb ne procesiram:  -->
    <xsl:template match="tei:pb">
        
    </xsl:template>
    <!-- milestone ne procesiram:  -->
    <xsl:template match="tei:milestone">
        
    </xsl:template>
    
    <xsl:template match="tei:fw">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <div class="pageNum">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:milestone[@xml:id=$content-start] or descendant::tei:milestone[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type = 'page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:call-template name="head">
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type = 'section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:call-template name="head">
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$processNotes='true'">
            <xsl:variable name="note-title">
                <xsl:variable name="note-text">
                    <xsl:apply-templates mode="besedilo"/>
                </xsl:variable>
                <xsl:value-of select="substring($note-text,1,150)"/>
                <xsl:if test="string-length($note-text) &gt; 150">
                    <xsl:text>…</xsl:text>
                </xsl:if>
            </xsl:variable>
            <span id="note.{@n}_return"><a class="notelink" title="{normalize-space(translate($note-title,'&#xA;&quot;&#92;','&#x20;'))}" href="#note.{@n}"><sup><xsl:value-of select="@n"/></sup></a></span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="node()" mode="besedilo" xml:space="preserve">
        <xsl:copy>
            <xsl:apply-templates select="node()" mode="besedilo"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:param name="process"/>
        <xsl:choose>
            <xsl:when test="$process='true'">
                <p>
                    <xsl:apply-templates>
                        <xsl:with-param name="process" select="$process"/>
                    </xsl:apply-templates>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$type='page'">
                    <xsl:choose>
                        <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                            <p>
                                <xsl:apply-templates>
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$content-start"/>
                                    <xsl:with-param name="content-end" select="$content-end"/>
                                    <xsl:with-param name="content-type" select="$content-type"/>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:apply-templates>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                                    <xsl:apply-templates>
                                        <xsl:with-param name="type" select="$type"/>
                                        <xsl:with-param name="mode" select="$mode"/>
                                        <xsl:with-param name="content-start" select="$content-start"/>
                                        <xsl:with-param name="content-end" select="$content-end"/>
                                        <xsl:with-param name="content-type" select="$content-type"/>
                                        <xsl:with-param name="lb" select="$lb"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="$type='section'">
                    <xsl:choose>
                        <xsl:when test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                            <p>
                                <xsl:apply-templates>
                                    <xsl:with-param name="type" select="$type"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                    <xsl:with-param name="content-start" select="$content-start"/>
                                    <xsl:with-param name="content-end" select="$content-end"/>
                                    <xsl:with-param name="content-type" select="$content-type"/>
                                    <xsl:with-param name="lb" select="$lb"/>
                                </xsl:apply-templates>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="descendant::tei:milestone[@xml:id=$content-start] or descendant::tei:milestone[@xml:id=$content-end]">
                                    <xsl:apply-templates>
                                        <xsl:with-param name="type" select="$type"/>
                                        <xsl:with-param name="mode" select="$mode"/>
                                        <xsl:with-param name="content-start" select="$content-start"/>
                                        <xsl:with-param name="content-end" select="$content-end"/>
                                        <xsl:with-param name="content-type" select="$content-type"/>
                                        <xsl:with-param name="lb" select="$lb"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:sp">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                    <blockquote>
                        <xsl:if test="@rend='linenumber' and $lb='1'">
                            <span class="numberParagraph">
                                <xsl:value-of select="@n"/>
                            </span>
                        </xsl:if>
                        <xsl:apply-templates>
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                    </blockquote>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                    <blockquote>
                        <xsl:if test="@rend='linenumber' and $lb='1'">
                            <span class="numberParagraph">
                                <xsl:value-of select="@n"/>
                            </span>
                        </xsl:if>
                        <xsl:apply-templates>
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                    </blockquote>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:milestone[@xml:id=$content-start] or descendant::tei:milestone[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <div class="padding">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <div class="padding">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- element speaker je child elementa sp -->
    <xsl:template match="tei:speaker">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <cite>
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </cite>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <cite>
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </cite>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:stage">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:call-template name="stage">
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:call-template name="stage">
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                    <blockquote>
                        <xsl:if test="@rend='linenumber' and $lb='1'">
                            <span class="numberParagraph">
                                <xsl:value-of select="@n"/>
                            </span>
                        </xsl:if>
                        <xsl:apply-templates>
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                    </blockquote>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <blockquote>
                    <xsl:if test="@rend='linenumber' and $lb='1'">
                        <span class="numberParagraph">
                            <xsl:value-of select="@n"/>
                        </span>
                    </xsl:if>
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </blockquote>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:lg/tei:l | tei:sp/tei:l">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:if test="@rend='linenumber' and $lb='1'">
                    <span class="numberParagraph">
                        <xsl:value-of select="@n"/>
                    </span>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:apply-templates>
                <xsl:choose>
                    <xsl:when test="$lb='1'">
                        <xsl:if test="position() != last()">
                            <br/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="position() != last()">
                            <span class="emph"> | </span>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:if test="@rend='linenumber' and $lb='1'">
                    <span class="numberParagraph">
                        <xsl:value-of select="@n"/>
                    </span>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:apply-templates>
                <xsl:choose>
                    <xsl:when test="$lb='1'">
                        <xsl:if test="position() != last()">
                            <br/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="position() != last()">
                            <span class="emph"> | </span>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <div class="{if (@rend) then ('text'|| @rend) else 'padding'}">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <div class="{if (@rend) then ('text-'|| @rend) else 'padding'}">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:call-template name="lb">
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:call-template name="lb">
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="lb">
        <xsl:param name="lb"/>
        <xsl:choose>
            <xsl:when test="@break = 'no'">
                <span class="emph"> | </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$lb='1'">
                        <br/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="emph"> | </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <span>
            <xsl:choose>
                <xsl:when test="@rend='bold'">
                    <xsl:attribute name="style">font-weight:bold;</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">hi</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:handShift">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:variable name="id" select="substring-after(@new,'#')"/>
        <span class="emph term">
            <xsl:text>→</xsl:text>
            <span class="explain">
                <xsl:text>sprememba roke → opomba o roki:</xsl:text>
                <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id=$id]">
                    <ul>
                        <li>pisar: <xsl:value-of select="@scribe || ' ' ||."/></li>
                    </ul>
                </xsl:for-each>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:supplied">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <span class="emph term">
            <xsl:apply-templates>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
            <span class="explain">
                <xsl:text>vstavil urednik:</xsl:text>
                <xsl:if test="@reason | @resp">
                    <ul>
                        <xsl:if test="@reason">
                            <li><!-- trenutno samo dve vrednosti za reason: omitted (izpuščen), damage (poškodba) -->
                                <xsl:value-of select="concat('vzrok: ', if (@reason='omitted') then 'izpuščen' else (if (@reason='damage') then 'poškodba' else ''))"/>
                            </li>
                        </xsl:if>
                        <xsl:if test="@resp">
                            <li><!-- trenutno samo dva urednika -->
                                <xsl:value-of select="concat('odgovornost: ', if (@resp='#MOG') then 'Matija Ogrin' else 'Erich Prunč')"/>
                            </li>
                        </xsl:if>
                    </ul>
                </xsl:if>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:choice[tei:abbr and tei:expan]">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$content-type = 'dipl'">
            <span class="choice term">
                <xsl:apply-templates select="tei:abbr"/>
                <span class="explain">
                    <xsl:text>okrajšava  &#x2192; razvezava: </xsl:text>
                    <xsl:value-of select="tei:expan"/>
                </span>
            </span>
        </xsl:if>
        <xsl:if test="$content-type = 'crit'">
            <span class="choice term">
                <xsl:apply-templates select="tei:expan"/>
                <span class="explain">
                    <xsl:text>razvezava &#x2190; okrajšava: </xsl:text>
                    <xsl:value-of select="tei:abbr"/>
                </span>
            </span>
        </xsl:if>
    </xsl:template> 
    
    <xsl:template match="tei:choice[tei:sic and tei:corr]">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$content-type = 'dipl'">
            <span class="choice term">
                <xsl:apply-templates select="tei:sic"/>
                <span class="explain">
                    <xsl:text>napaka &#x2192; uredniški popravek: </xsl:text>
                    <xsl:value-of select="tei:corr"/>
                </span>
            </span>
        </xsl:if>
        <xsl:if test="$content-type = 'crit'">
            <span class="choice term">
                <xsl:apply-templates select="tei:corr"/>
                <span class="explain">
                    <xsl:text>uredniški popravek &#x2190; napaka: </xsl:text>
                    <xsl:value-of select="tei:sic"/>
                </span>
            </span>
        </xsl:if>
    </xsl:template>
    
    <!-- Obstaja primer, ko se w v reg razdeli na dve strani (samo pri diplomatičnem prepisu) -->
    <xsl:template match="tei:choice[tei:orig and tei:reg]">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$content-type = 'dipl'">
            <xsl:if test="$type='page'">
                <xsl:choose>
                    <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                        <span class="choice term">
                            <xsl:apply-templates select="tei:orig">
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                            <xsl:call-template name="content-choice-orig"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                                <span class="choice term">
                                    <xsl:apply-templates select="tei:orig">
                                        <xsl:with-param name="type" select="$type"/>
                                        <xsl:with-param name="mode" select="$mode"/>
                                        <xsl:with-param name="content-start" select="$content-start"/>
                                        <xsl:with-param name="content-end" select="$content-end"/>
                                        <xsl:with-param name="content-type" select="$content-type"/>
                                        <xsl:with-param name="lb" select="$lb"/>
                                    </xsl:apply-templates>
                                    <xsl:call-template name="content-choice-orig"/>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$type='section'">
                <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                    <span class="choice term">
                        <xsl:apply-templates select="tei:orig">
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                        <xsl:call-template name="content-choice-orig"/>
                    </span>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$content-type = 'crit'">
            <span class="choice term">
                <xsl:apply-templates select="tei:reg"/>
                <span class="explain">
                    <xsl:text>regularizirano &#x2190; izvorna oblika: </xsl:text>
                    <xsl:value-of select="tei:orig"/>
                </span>
            </span>
        </xsl:if>
    </xsl:template>
    
    <!-- procesiram zaradi notranjega deljenja besed -->
    <xsl:template match="tei:orig">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:apply-templates>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <!-- subst[del and add] -->
    <xsl:template match="tei:subst">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:apply-templates>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="mode" select="$mode"/>
            <xsl:with-param name="content-start" select="$content-start"/>
            <xsl:with-param name="content-end" select="$content-end"/>
            <xsl:with-param name="content-type" select="$content-type"/>
            <xsl:with-param name="lb" select="$lb"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <del>
            <xsl:apply-templates>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
        </del>
    </xsl:template>
    
    <!-- moram še procesirati atribut @hand -->
    <xsl:template match="tei:add">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:variable name="place" select="if (@place='above') then 'sup' else (if (@place='below') then 'sub' else '')"/>
        <xsl:choose>
            <xsl:when test="string-length($place) gt 0">
                <xsl:element name="{$place}">
                    <ins>
                        <xsl:apply-templates>
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                    </ins>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <ins>
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </ins>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:unclear">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <span class="unclear">
            <xsl:apply-templates>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="content-start" select="$content-start"/>
                <xsl:with-param name="content-end" select="$content-end"/>
                <xsl:with-param name="content-type" select="$content-type"/>
                <xsl:with-param name="lb" select="$lb"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <span class="emph term">
            <xsl:text>[...]</xsl:text>
            <span class="explain">
                <xsl:text>vrzel:</xsl:text>
                <ul>
                    <xsl:if test="@reason">
                        <li>
                            <xsl:text>vzrok: </xsl:text>
                            <xsl:if test="@reason='damage'">poškodovano</xsl:if>
                            <xsl:if test="@reason='omitted'">izpuščeno</xsl:if>
                            <xsl:if test="@reason='missing'">manjkajoče</xsl:if>
                            <xsl:if test="@reason='cancelled'">prekinjeno</xsl:if>
                        </li>
                    </xsl:if>
                    <xsl:if test="@unit">
                        <li>
                            <xsl:text>enota: </xsl:text>
                            <xsl:if test="@unit='chars'">znaki</xsl:if>
                            <xsl:if test="@unit='words'">besede</xsl:if>
                            <xsl:if test="@unit='pages'">strani</xsl:if>
                            <xsl:if test="@quantity">
                                <xsl:text>; količina: </xsl:text>
                                <xsl:value-of select="@quantity"/>
                            </xsl:if>
                        </li>
                    </xsl:if>
                </ul>
                <xsl:if test="tei:desc">
                    <hr/>
                    <!-- Do sedaj je opise dajal samo  -->
                    <xsl:text>opis (odgovornost: Erich Prunč): </xsl:text>
                    <xsl:value-of select="tei:desc"/>
                </xsl:if>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:choose>
                <xsl:when test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                    <span class="term">
                        <xsl:apply-templates>
                            <xsl:with-param name="type" select="$type"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="content-start" select="$content-start"/>
                            <xsl:with-param name="content-end" select="$content-end"/>
                            <xsl:with-param name="content-type" select="$content-type"/>
                            <xsl:with-param name="lb" select="$lb"/>
                        </xsl:apply-templates>
                        <xsl:call-template name="content-word"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="descendant::tei:pb[@xml:id=$content-start] or descendant::tei:pb[@xml:id=$content-end]">
                            <xsl:apply-templates>
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="mode" select="$mode"/>
                                <xsl:with-param name="content-start" select="$content-start"/>
                                <xsl:with-param name="content-end" select="$content-end"/>
                                <xsl:with-param name="content-type" select="$content-type"/>
                                <xsl:with-param name="lb" select="$lb"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <span class="term">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                    <xsl:call-template name="content-word"/>
                </span>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:pc">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:value-of select="."/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:value-of select="."/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:c">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="$type='page'">
            <xsl:if test="if ($content-end='') then (preceding::tei:pb[1][@xml:id=$content-start]) else (preceding::tei:pb[1][@xml:id=$content-start]  and following::tei:pb[1][@xml:id=$content-end])">
                <xsl:text> </xsl:text> 
            </xsl:if>
        </xsl:if>
        <xsl:if test="$type='section'">
            <xsl:if test="if ($content-end='') then (preceding::tei:milestone[1][@xml:id=$content-start]) else (preceding::tei:milestone[1][@xml:id=$content-start]  and following::tei:milestone[1][@xml:id=$content-end])">
                <xsl:text> </xsl:text> 
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="content-word">
        <span class="explain">
            <ul>
                <xsl:if test="@lemma">
                    <li>lemma: <xsl:value-of select="@lemma"/></li>
                </xsl:if>
                <li>
                    <a href="{concat('http://nl.ijs.si/noske/all.cgi/view?corpname=kapelski;usesubcorp=;q=q%5Bword%3D%3D%22',.,'%22%5D')}" target="_blank">NoSketch</a>
                </li>
            </ul>
        </span>
    </xsl:template>
    
    <xsl:template name="content-choice-orig">
        <span class="explain">
            <xsl:text>izvorna oblika &#x2192; regularizirano: </xsl:text>
            <hr/>
            <xsl:choose>
                <xsl:when test="descendant::tei:w">
                    <ul>
                        <xsl:if test="tei:orig/tei:w">
                            <xsl:for-each select="tei:orig/tei:w">
                                <li><xsl:text>izvorna oblika: </xsl:text><xsl:value-of select="."/><ul>
                                    <xsl:if test="@lemma">
                                        <li>lemma: <xsl:value-of select="@lemma"/></li>
                                    </xsl:if>
                                    <li>
                                        <a href="{concat('http://nl.ijs.si/noske/all.cgi/view?corpname=kapelski;usesubcorp=;q=q%5Bword%3D%3D%22',.,'%22%5D')}" target="_blank">NoSketch</a>
                                    </li>
                                </ul>
                                </li>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="tei:reg/tei:w">
                            <xsl:for-each select="tei:reg/tei:w">
                                <li><xsl:text>regularizirano: </xsl:text><xsl:value-of select="."/><ul>
                                    <xsl:if test="@lemma">
                                        <li>lemma: <xsl:value-of select="@lemma"/></li>
                                    </xsl:if>
                                    <li>
                                        <a href="{concat('http://nl.ijs.si/noske/all.cgi/view?corpname=kapelski;usesubcorp=;q=q%5Bword%3D%3D%22',.,'%22%5D')}" target="_blank">NoSketch</a>
                                    </li>
                                </ul>
                                </li>
                            </xsl:for-each>
                        </xsl:if>
                    </ul>
                    <xsl:if test="descendant::tei:lb[@break='no']">
                        <hr/><xsl:text>vsebuje prelom vrstice: |</xsl:text>
                    </xsl:if>
                    <xsl:if test="descendant::tei:pb">
                        <hr/><xsl:text>vsebuje prelom strani: </xsl:text>
                        <xsl:value-of select="descendant::tei:fw"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="tei:reg"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template name="head">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:if test="parent::tei:div[@type = 'crit' or @type = 'dipl']">
            <h3>
                <xsl:apply-templates>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:apply-templates>
            </h3>
        </xsl:if>
        <xsl:if test="parent::tei:div[@type = 'subsection']">
            <h4>
                <xsl:apply-templates>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:apply-templates>
            </h4>
        </xsl:if>
        <xsl:if test="parent::tei:div[@type = 'subsubsection']">
            <h5>
                <xsl:apply-templates>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="content-start" select="$content-start"/>
                    <xsl:with-param name="content-end" select="$content-end"/>
                    <xsl:with-param name="content-type" select="$content-type"/>
                    <xsl:with-param name="lb" select="$lb"/>
                </xsl:apply-templates>
            </h5>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="stage">
        <xsl:param name="type"/>
        <xsl:param name="mode"/>
        <xsl:param name="content-start"/>
        <xsl:param name="content-end"/>
        <xsl:param name="content-type"/>
        <xsl:param name="lb"/>
        <xsl:choose>
            <xsl:when test="parent::tei:div">
                <p class="stage">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <span class="stage">
                    <xsl:apply-templates>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="content-start" select="$content-start"/>
                        <xsl:with-param name="content-end" select="$content-end"/>
                        <xsl:with-param name="content-type" select="$content-type"/>
                        <xsl:with-param name="lb" select="$lb"/>
                    </xsl:apply-templates>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
</xsl:stylesheet>
