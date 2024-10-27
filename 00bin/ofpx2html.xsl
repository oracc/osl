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
	<xsl:sort select="@sort" data-type="number"/>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="o:sign">
    <tr>
      <td><xsl:value-of select="@n"/></td>
      <td><xsl:value-of select="@xml:id"/></td>
      <td><span class="{$css} ofs-150"><xsl:value-of select="@utf8"/></span></td>
      <td>
	<xsl:if test="@l">
	  <xsl:text>(</xsl:text>
	  <xsl:value-of select="@l"/>
	  <xsl:text> = </xsl:text>
	  <span class="{$css} ofs-150"><xsl:value-of select="zwnj"/></span>
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </td>
    </tr>
  </xsl:template>
  
</xsl:transform>
