<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    extension-element-prefixes="ixsl"
    exclude-result-prefixes="xs tei lido"
    version="3.0">
    
    <xsl:template match="/">
        <xsl:variable name="ident" select="(ixsl:query-params()?id)"/>
        <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@type='lido']/tei:list[@type='deathMask']/tei:item[substring-after(@xml:id,'sistory-') = $ident]">
            <xsl:result-document href="#maska" method="ixsl:replace-content">
                <h3 class="text-center">
                    <xsl:value-of select="tei:list/tei:item[preceding-sibling::tei:label[1] = 'Naziv']"/>
                </h3>
                <xsl:for-each select="document(tei:list/tei:item/tei:ptr/@target)">
                    <xsl:choose>
                        <!-- če so slike, jih postavimo v stolpec levo od metapdoatkov -->
                        <xsl:when test="lido:lidoWrap/lido:lido/lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet">
                            <div class="row">
                                <div class="medium-6 columns">
                                    <xsl:for-each select="lido:lidoWrap/lido:lido/lido:administrativeMetadata/lido:resourceWrap/lido:resourceSet">
                                        <xsl:variable name="filePath" select="lido:resourceRepresentation/lido:linkResource"/>
                                        <figure class="figure">
                                            <figcaption class="caption">
                                                <xsl:value-of select="lido:resourceDescription"/>
                                            </figcaption>
                                            <a class="image-popup" href="{$filePath}" target="_blank">
                                                <img src="{$filePath}" alt="Slika" style="height:350px"/>
                                            </a>
                                            <xsl:if test="lido:resourceSource">
                                                <p>
                                                    <xsl:text>Pravice: </xsl:text>
                                                    <xsl:value-of select="lido:resourceSource/lido:legalBodyName/lido:appellationValue"/>
                                                </p>
                                            </xsl:if>
                                        </figure>
                                        <xsl:if test="position() != last()">
                                            <br/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </div>
                                <div class="medium-6 columns">
                                    <xsl:call-template name="lido"/>
                                </div>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="lido"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="lido">
        <xsl:for-each select="lido:lidoWrap/lido:lido">
            <xsl:for-each select="lido:descriptiveMetadata">
                <dt>Opisni metapodatki</dt>
                <dd>
                    <xsl:for-each select="lido:objectIdentificationWrap">
                        <dl>
                            <dt>Identifikacija objekta</dt>
                            <dd>
                                <dl>
                                    <xsl:for-each select="lido:repositoryWrap/lido:repositorySet">
                                        <dt>Repozitorij</dt>
                                        <dd>
                                            <xsl:value-of select="lido:repositoryName/lido:legalBodyName/lido:appellationValue"/>
                                            <xsl:if test="lido:workID or lido:repositoryLocation">
                                                <dl>
                                                    <xsl:for-each select="lido:workID">
                                                        <dt>Identifikator dela</dt>
                                                        <dd><xsl:value-of select="."/></dd>
                                                    </xsl:for-each>
                                                    <xsl:for-each select="lido:repositoryLocation">
                                                        <dt>Nahajališče</dt>
                                                        <dd><xsl:value-of select="lido:namePlaceSet/lido:appellationValue"/></dd>
                                                    </xsl:for-each>
                                                </dl>
                                            </xsl:if>
                                        </dd>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectDescriptionWrap">
                                        <dt>Opisi</dt>
                                        <dd>
                                            <dl>
                                                <xsl:for-each select="lido:objectDescriptionSet">
                                                    <dt>
                                                        <xsl:if test="@lido:type = 'description'">Opis</xsl:if>
                                                        <xsl:if test="@lido:type = 'condition'">Stanje predmeta</xsl:if>
                                                        <xsl:if test="@lido:type = 'conditionNote'">Oznake</xsl:if>
                                                    </dt>
                                                    <dd><xsl:value-of select="lido:descriptiveNoteValue"/></dd>
                                                </xsl:for-each>
                                            </dl>
                                        </dd>
                                    </xsl:for-each>
                                    <xsl:for-each select="lido:objectMeasurementsWrap">
                                        <dt>Mere objekta</dt>
                                        <dd>
                                            <xsl:choose>
                                                <xsl:when test="lido:objectMeasurementsSet/lido:objectMeasurements">
                                                    <xsl:for-each select="lido:objectMeasurementsSet/lido:objectMeasurements">
                                                        <dl>
                                                            <xsl:for-each select="lido:measurementsSet">
                                                                <dt><xsl:value-of select="lido:measurementType"/></dt>
                                                                <dd><xsl:value-of select="concat(lido:measurementValue,' ',lido:measurementUnit)"/></dd>
                                                            </xsl:for-each>
                                                        </dl>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="lido:objectMeasurementsSet/lido:displayObjectMeasurements"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </dd>
                                    </xsl:for-each>
                                </dl>
                            </dd>
                        </dl>
                    </xsl:for-each>
                    <xsl:for-each select="lido:eventWrap">
                        <dl>
                            <dt>Dogodki</dt>
                            <dd>
                                <xsl:for-each select="lido:eventSet/lido:event">
                                    <dl>
                                        <dt><xsl:value-of select="lido:eventType/lido:term[not(@xml:lang)]"/></dt>
                                        <dd>
                                            <dl>
                                                <xsl:for-each select="lido:eventActor/lido:actorInRole">
                                                    <dt><xsl:value-of select="lido:roleActor/lido:term[not(@xml:lang)]"/></dt>
                                                    <dd><xsl:value-of select="lido:actor/lido:nameActorSet/lido:appellationValue"/></dd>
                                                </xsl:for-each>
                                                <xsl:for-each select="lido:eventMaterialsTech/lido:materialsTech">
                                                    <dt>Material in tehnika</dt>
                                                    <dd><xsl:value-of select="lido:termMaterialsTech/lido:term"/></dd>
                                                </xsl:for-each>
                                                <xsl:for-each select="lido:eventDate">
                                                    <dt>Datum</dt>
                                                    <dd><xsl:value-of select="lido:displayDate"/></dd>
                                                </xsl:for-each>
                                                <xsl:for-each select="lido:eventDescriptionSet">
                                                    <dt>Opis</dt>
                                                    <dd><xsl:value-of select="lido:descriptiveNoteValue"/></dd>
                                                </xsl:for-each>
                                            </dl>
                                        </dd>
                                    </dl>
                                </xsl:for-each>
                            </dd>
                        </dl>
                    </xsl:for-each>
                </dd>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
