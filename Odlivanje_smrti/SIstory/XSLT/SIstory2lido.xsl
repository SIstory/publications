<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.sistory.si/schemas/sistory/"
    xmlns:sistory="http://www.sistory.si/schemas/sistory/"
    xmlns:lido="http://www.lido-schema.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs sistory"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Določim sistory ID zadnje prejšnje pretvorbe. 
         Namen: ker se lahko pretvorjene LIDO metapodatke kasneje popravlja na roko, nočemo, da nova pretvorba "povozi" te popravke.
     -->
    <xsl:param name="processingFromSIstoryID">0</xsl:param>
    <!-- PAZI: nujno vnesi vrednost zgornjega parametra processingFromSIstoryID, drugače bo procesiral vse publication od 0 dalje
         Pretvorimo lahko točno določeno sistory publikacijo.
         Namen: Ker lahko v sistory naknadno popravljamo vpisane metapodatke, je te spremembe potrebno pretvoriti v LIDO,
         čeprav je pred tem že bil narejen metadata.xml -->
    <xsl:param name="processingSIstoryID">0</xsl:param>
    <xsl:param name="outputDir">/Users/administrator/Documents/moje/publikacije/Odlivanje_smrti/LIDO/</xsl:param>
    
    <xsl:template match="sistory:root">
        <xsl:for-each select="sistory:publication[xs:integer(sistory:ID) gt xs:integer($processingFromSIstoryID)] | 
                              sistory:publication[xs:integer(sistory:ID) = xs:integer($processingSIstoryID)]">
            <xsl:variable name="sistoryID" select="sistory:ID"/>
            <xsl:result-document href="{concat($outputDir,$sistoryID,'/metadata.xml')}">
                <lido:lidoWrap xmlns:lido="http://www.lido-schema.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.lido-schema.org http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd">
                    <lido:lido>
                        <lido:lidoRecID lido:type="local" lido:label="SIstory">
                            <xsl:value-of select="concat('http://hdl.handle.net/',sistory:URN)"/>
                        </lido:lidoRecID>
                        <lido:category>
                            <lido:conceptID lido:type="URI">http://purl.org/dc/terms/type</lido:conceptID>
                            <lido:term xml:lang="en">
                                <xsl:value-of select="normalize-space(translate(sistory:TYPE_DC/@title,' ',''))"/>
                            </lido:term>
                        </lido:category>
                        <lido:descriptiveMetadata xml:lang="sl">
                            <lido:objectClassificationWrap>
                                <lido:objectWorkTypeWrap>
                                    <lido:objectWorkType>
                                        <lido:conceptID lido:source="http://vocab.getty.edu/aat" lido:type="ID">300047724</lido:conceptID>
                                        <lido:term>Posmrtna maska</lido:term>
                                    </lido:objectWorkType>
                                </lido:objectWorkTypeWrap>
                                <lido:classificationWrap>
                                    <lido:classification>
                                        <lido:conceptID lido:type="person">Upodobljenec</lido:conceptID>
                                        <xsl:for-each select="sistory:SUBJECT">
                                            <lido:term>
                                                <xsl:call-template name="language-attribute"/>
                                                <xsl:value-of select="."/>
                                            </lido:term>
                                        </xsl:for-each>
                                    </lido:classification>
                                </lido:classificationWrap>
                            </lido:objectClassificationWrap>
                            <lido:objectIdentificationWrap>
                                <lido:titleWrap>
                                    <lido:titleSet>
                                        <xsl:for-each select="sistory:TITLE[@titleType='Title']">
                                            <lido:appellationValue>
                                                <xsl:value-of select="."/>
                                            </lido:appellationValue>
                                        </xsl:for-each>
                                    </lido:titleSet>
                                </lido:titleWrap>
                                <xsl:if test="sistory:COLLECTION | sistory:IDENTIFIER[@identifierType='Identifier'] | sistory:RIGHTS[@rightsType='accessRights']">
                                    <lido:repositoryWrap>
                                        <lido:repositorySet lido:type="current">
                                            <xsl:if test="sistory:COLLECTION">
                                                <lido:repositoryName>
                                                    <lido:legalBodyName>
                                                        <lido:appellationValue>
                                                            <xsl:value-of select="sistory:COLLECTION"/>
                                                        </lido:appellationValue>
                                                    </lido:legalBodyName>
                                                </lido:repositoryName>
                                            </xsl:if>
                                            <xsl:if test="sistory:IDENTIFIER[@identifierType='Identifier']">
                                                <lido:workID>
                                                    <xsl:value-of select="sistory:IDENTIFIER[@identifierType='Identifier']"/>
                                                </lido:workID>
                                            </xsl:if>
                                            <xsl:if test="sistory:RIGHTS[@rightsType='accessRights']">
                                                <lido:repositoryLocation>
                                                    <lido:namePlaceSet>
                                                        <lido:appellationValue xml:lang="{sistory:RIGHTS[@rightsType='accessRights']/@lang}">
                                                            <xsl:value-of select="sistory:RIGHTS[@rightsType='accessRights']"/>
                                                        </lido:appellationValue>
                                                    </lido:namePlaceSet>
                                                </lido:repositoryLocation>
                                            </xsl:if>
                                        </lido:repositorySet>
                                    </lido:repositoryWrap>
                                </xsl:if>
                                <xsl:if test="sistory:DESCRIPTION[@descriptionType='Description'] or sistory:SLIKOVNI[@slikovniElType='visTechAttribute']">
                                    <lido:objectDescriptionWrap>
                                        <xsl:for-each select="sistory:DESCRIPTION[@descriptionType='Description']">
                                            <lido:objectDescriptionSet lido:type="description">
                                                <lido:descriptiveNoteValue>
                                                    <xsl:call-template name="language-attribute"/>
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </lido:descriptiveNoteValue>
                                            </lido:objectDescriptionSet>
                                        </xsl:for-each>
                                        <xsl:for-each select="sistory:SLIKOVNI[@slikovniElType='visTechAttribute']">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,'ohranje') or contains(.,'stanju')">
                                                    <lido:objectDescriptionSet lido:type="condition">
                                                        <lido:descriptiveNoteValue>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </lido:descriptiveNoteValue>
                                                    </lido:objectDescriptionSet>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <lido:objectDescriptionSet lido:type="conditionNote">
                                                        <lido:descriptiveNoteValue>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </lido:descriptiveNoteValue>
                                                    </lido:objectDescriptionSet>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </lido:objectDescriptionWrap>
                                </xsl:if>
                                <xsl:if test="sistory:SLIKOVNI[@slikovniElType='visDimensions']">
                                    <lido:objectMeasurementsWrap>
                                        <xsl:for-each select="sistory:SLIKOVNI[@slikovniElType='visDimensions']">
                                            <lido:objectMeasurementsSet>
                                                <lido:displayObjectMeasurements>
                                                    <xsl:value-of select="."/>
                                                </lido:displayObjectMeasurements>
                                                <xsl:if test="matches(.,'v:|š:|d:|g:') and contains(.,';')">
                                                    <lido:objectMeasurements>
                                                        <xsl:for-each select="tokenize(.,';|,')">
                                                            <xsl:if test="string-length(.) gt 0">
                                                                <lido:measurementsSet>
                                                                    <lido:measurementType>
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains(.,'v:')">Višina</xsl:when>
                                                                            <xsl:when test="contains(.,'š:')">Širina</xsl:when>
                                                                            <xsl:when test="contains(.,'d:')">Dolžina</xsl:when>
                                                                            <xsl:when test="contains(.,'g:')">Globina</xsl:when>
                                                                        </xsl:choose>
                                                                    </lido:measurementType>
                                                                    <lido:measurementUnit>
                                                                        <xsl:choose>
                                                                            <xsl:when test="contains(.,' cm')">cm</xsl:when>
                                                                        </xsl:choose>
                                                                    </lido:measurementUnit>
                                                                    <lido:measurementValue>
                                                                        <xsl:analyze-string select="." regex="\d+">
                                                                            <xsl:matching-substring>
                                                                                <xsl:value-of select="."/>
                                                                            </xsl:matching-substring>
                                                                        </xsl:analyze-string>
                                                                    </lido:measurementValue>
                                                                </lido:measurementsSet>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </lido:objectMeasurements>
                                                </xsl:if>
                                            </lido:objectMeasurementsSet>
                                        </xsl:for-each>
                                    </lido:objectMeasurementsWrap>
                                </xsl:if>
                            </lido:objectIdentificationWrap>
                            <lido:eventWrap>
                                <lido:eventSet>
                                    <lido:event>
                                        <lido:eventType>
                                            <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00007</lido:conceptID>
                                            <lido:term xml:lang="en">Production</lido:term>
                                            <lido:term>Izdelovanje</lido:term>
                                        </lido:eventType>
                                        <xsl:for-each select="sistory:CREATOR">
                                            <lido:eventActor>
                                                <lido:actorInRole>
                                                    <lido:actor>
                                                        <lido:nameActorSet>
                                                            <lido:appellationValue>
                                                                <xsl:value-of select="sistory:PRIIMEK"/>
                                                                <xsl:if test=" string-length(sistory:PRIIMEK) gt 0 and string-length(sistory:IME) gt 0">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                                <xsl:value-of select="sistory:IME"/>
                                                            </lido:appellationValue>
                                                        </lido:nameActorSet>
                                                    </lido:actor>
                                                    <lido:roleActor>
                                                        <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00163</lido:conceptID>
                                                        <lido:term xml:lang="en">Person</lido:term>
                                                        <lido:term>Oseba</lido:term>
                                                    </lido:roleActor>
                                                </lido:actorInRole>
                                            </lido:eventActor>
                                        </xsl:for-each>
                                        <xsl:for-each select="sistory:SLIKOVNI[@slikovniElType='visTechnique']">
                                            <lido:eventMaterialsTech>
                                                <lido:materialsTech>
                                                    <lido:termMaterialsTech>
                                                        <lido:term>
                                                            <xsl:value-of select="."/>
                                                        </lido:term>
                                                    </lido:termMaterialsTech>
                                                </lido:materialsTech>
                                            </lido:eventMaterialsTech>
                                        </xsl:for-each>
                                    </lido:event>
                                </lido:eventSet>
                                <xsl:if test="sistory:CONTRIBUTOR or sistory:DATE[@type='Date']">
                                    <lido:eventSet>
                                        <lido:event>
                                            <lido:eventType>
                                                <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00226</lido:conceptID>
                                                <lido:term xml:lang="en">Commissioning</lido:term>
                                                <lido:term>Naročilo</lido:term>
                                            </lido:eventType>
                                            <xsl:for-each select="sistory:CONTRIBUTOR">
                                                <lido:eventActor>
                                                    <lido:actorInRole>
                                                        <lido:actor>
                                                            <lido:nameActorSet>
                                                                <lido:appellationValue>
                                                                    <xsl:value-of select="normalize-space(substring-before(.,'('))"/>
                                                                </lido:appellationValue>
                                                            </lido:nameActorSet>
                                                        </lido:actor>
                                                        <lido:roleActor>
                                                            <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00163</lido:conceptID>
                                                            <lido:term xml:lang="en">Person</lido:term>
                                                            <lido:term>Oseba</lido:term>
                                                        </lido:roleActor>
                                                    </lido:actorInRole>
                                                </lido:eventActor>
                                            </xsl:for-each>
                                            <xsl:for-each select="sistory:DATE[@type='Date']">
                                                <lido:eventDate>
                                                    <lido:displayDate>
                                                        <xsl:value-of select="."/>
                                                    </lido:displayDate>
                                                    <xsl:choose>
                                                        <xsl:when test="matches(.,'pred\s\d{4}')">
                                                            <lido:date>
                                                                <lido:latestDate>
                                                                    <xsl:value-of select="substring-after(.,'pred ')"/>
                                                                </lido:latestDate>
                                                            </lido:date>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <lido:date>
                                                                <lido:earliestDate>
                                                                    <xsl:value-of select="."/>
                                                                </lido:earliestDate>
                                                                <lido:latestDate>
                                                                    <xsl:value-of select="."/>
                                                                </lido:latestDate>
                                                            </lido:date>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </lido:eventDate>
                                            </xsl:for-each>
                                        </lido:event>
                                    </lido:eventSet>
                                </xsl:if>
                                <xsl:if test="sistory:OTHER[@otherType='provenance']">
                                    <lido:eventSet>
                                        <lido:event>
                                            <lido:eventType>
                                                <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00227</lido:conceptID>
                                                <lido:term xml:lang="en">Provenance</lido:term>
                                                <lido:term>Provenienca</lido:term>
                                            </lido:eventType>
                                            <xsl:for-each select="sistory:OTHER[@otherType='provenance']">
                                                <lido:eventDescriptionSet>
                                                    <lido:descriptiveNoteValue>
                                                        <xsl:call-template name="language-attribute"/>
                                                        <xsl:value-of select="."/>
                                                    </lido:descriptiveNoteValue>
                                                </lido:eventDescriptionSet>
                                            </xsl:for-each>
                                        </lido:event>
                                    </lido:eventSet>
                                </xsl:if>
                            </lido:eventWrap>
                        </lido:descriptiveMetadata>
                        <lido:administrativeMetadata xml:lang="sl">
                            <lido:recordWrap>
                                <lido:recordID lido:type="PID">
                                    <xsl:value-of select="sistory:ID"/>
                                </lido:recordID>
                                <lido:recordType>
                                    <lido:conceptID lido:source="http://terminology.lido-schema.org" lido:type="ID">lido00141</lido:conceptID>
                                    <lido:term xml:lang="en">Item-level record</lido:term>
                                    <lido:term>posamezen objekt</lido:term>
                                </lido:recordType>
                                <lido:recordSource>
                                    <lido:legalBodyName>
                                        <lido:appellationValue>Društvo za domače raziskave</lido:appellationValue>
                                    </lido:legalBodyName>
                                    <lido:legalBodyWeblink>http://ddr.si</lido:legalBodyWeblink>
                                </lido:recordSource>
                            </lido:recordWrap>
                        </lido:administrativeMetadata>
                    </lido:lido>
                </lido:lidoWrap>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="language-attribute">
        <xsl:if test="@lang ne 'slv'">
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="@lang"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>