<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:x="http://oracc.org/ns/xtf/1.0"
    xmlns:g="http://oracc.org/ns/gdl/1.0"
    >
  <xsl:output method="text" encoding="utf8"/>

  <xsl:template name="oid-atf">
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="@oid"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="@atf"/>
  </xsl:template>

  <xsl:template match="g:v|g:s">
    <xsl:call-template name="oid-atf"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:choose>
      <xsl:when test="g:b">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="g:b">
    <xsl:value-of select="text()"/>    
  </xsl:template>
  
  <xsl:template match="g:m">
    <xsl:value-of select="concat('@',text())"/>
  </xsl:template>
  
  <xsl:template match="g:c">
    <xsl:call-template name="oid-atf"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="@form"/>
  </xsl:template>

  <xsl:template match="g:q">
    <xsl:call-template name="oid-atf"/>
    <xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="*[1]/text()"/>
  </xsl:template>

  <xsl:template match="x:l">
    <xsl:value-of select="@n"/>
    <xsl:choose>
      <xsl:when test="count(g:w) = 2">
	<xsl:apply-templates select="g:w/*"/>
      </xsl:when>
      <xsl:when test="count(g:w) = 1">
	<xsl:apply-templates select="g:w/*"/>
	<xsl:text>&#x9;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Line <xsl:value-of select="@n"/>. has <xsl:value-of select="count(g:w)"
	/> g:w nodes not 1 or 2</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:transform>
