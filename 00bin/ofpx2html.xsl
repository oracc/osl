<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:o="http://oracc.org/ns/ofp/1.0"
	       xmlns:xh="http://www.w3.org/1999/xhtml"
	       xmlns="http://www.w3.org/1999/xhtml"
	       version="1.0">

  <xsl:output method="xml" encoding="UTF-8"
	      omit-xml-declaration="yes" indent="yes"/>
  <xsl:param name="css"/>
  
  <xsl:template match="o:ofp">
    <table class="pretty">
      <xsl:apply-templates select="*[@oid]">
	<xsl:sort select="@lsort" data-type="number"/>
	<xsl:sort select="@sort" data-type="number"/>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="o:sign">
    <xsl:call-template name="sign-or-liga"/>
    <xsl:for-each select="o:ligas/*">
      <xsl:call-template name="sign-or-liga">
	<xsl:with-param name="liga" select="true()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="sign-or-liga">
    <xsl:param name="liga" select="false()"/>
    <tr>
      <td>
	<xsl:choose>
	  <xsl:when test="$liga"/>
	  <xsl:otherwise>
	    <xsl:value-of select="@list"/>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
      <td><xsl:value-of select="@n"/></td>
      <td><xsl:value-of select="@xml:id"/></td>
      <td><p><span class="{$css} ofs-150"><xsl:value-of select="@utf8"/></span></p></td>
      <td>
	<xsl:if test="@l">
	  <p>
	    <xsl:text>(</xsl:text>
	    <xsl:value-of select="@l"/>
	    <xsl:text> = </xsl:text>
	    <span class="{$css} ofs-150"><xsl:value-of select="@zwnj"/></span>
	    <xsl:text>)</xsl:text>
	  </p>
	</xsl:if>
      </td>
    </tr>
    <xsl:call-template name="feature">
      <xsl:with-param name="nodes" select="o:ssets/*"/>
      <xsl:with-param name="label" select="'sset'"/>
    </xsl:call-template>
    <xsl:call-template name="feature">
      <xsl:with-param name="nodes" select="o:salts/*"/>
      <xsl:with-param name="label" select="'salt'"/>
    </xsl:call-template>
    <xsl:call-template name="feature">
      <xsl:with-param name="nodes" select="o:ligas/*"/>
      <xsl:with-param name="label" select="'liga'"/>
    </xsl:call-template>
    <xsl:call-template name="feature">
      <xsl:with-param name="nodes" select="o:cvnns/*"/>
      <xsl:with-param name="label" select="'cvnn'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="feature">
    <xsl:param name="nodes"/>
    <xsl:param name="label"/>
    <xsl:for-each select="$nodes">
      <tr>
	<td><xsl:value-of select="@list"/></td>
	<td class="ofs-feat-r"><xsl:value-of select="$label"/></td>
	<td><xsl:value-of select="."/></td>
	<xsl:variable name="fcss">
	  <xsl:choose>
	    <xsl:when test="$label='salt'"><xsl:value-of select="concat('salt',.)"/></xsl:when>
	    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<td>
	  <p>
	    <span class="{$css} {$fcss} ofs-150">
	      <xsl:choose>
		<xsl:when test="$label='liga'">
		  <xsl:value-of select="@utf8"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="ancestor::o:sign/@utf8"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </span>
	  </p>
	</td>
	<td>
	  <xsl:if test="@l">
	    <p>
	      <xsl:text>(</xsl:text>
	      <xsl:value-of select="@l"/>
	      <xsl:text> = </xsl:text>
	      <span class="{$css} ofs-150"><xsl:value-of select="@zwnj"/></span>
	      <xsl:text>)</xsl:text>
	    </p>
	  </xsl:if>
	</td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  
</xsl:transform>
