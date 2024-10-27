<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:o="http://oracc.org/ns/ofp/1.0"
	       xmlns:xh="http://www.w3.org/1999/xhtml"
	       xmlns="http://www.w3.org/1999/xhtml"
	       version="1.0">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:param name="css"/>
  
  <xsl:template match="o:ofp">
    <table class="pretty">
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="o:sign">
    <tr>
      <td><xsl:value-of select="@n"/></td>
      <td><xsl:value-of select="@xml:id"/></td>
      <td><span class="{$css}"><xsl:value-of select="@utf8"/></span></td>
    </tr>
  </xsl:template>
  
</xsl:transform>
