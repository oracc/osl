<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	       xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="lak">
    <html>
      <head>
	<meta charset="utf-8"/>
	<title>LAK Proofing Page</title>
	<link rel="stylesheet" href="/osl/lakproof.css"/>
	<link rel="stylesheet" href="/css/fonts.css"/>
      </head>
      <body>
	<h1>LAK Proofing Page</h1>
	<p>Sign forms are Noto, Oracc-LAK, SVG.</p>
	<table>
	  <xsl:apply-templates/>
	</table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="entry">
    <tr class="entry">
      <td class="ent-lak"><xsl:value-of select="@l"/></td>
      <td class="ent-name"><a href="/osl/signlist/{@oid}"><xsl:value-of select="@n"/></a></td>
      <td class="ent-items">
	<table>
	  <xsl:apply-templates select="sub"/>
	</table>
      </td>
    </tr>
    <xsl:apply-templates select="rows/row"/>
  </xsl:template>

  <xsl:template match="sub">
    <xsl:variable name="salt">
      <xsl:if test="@salt"><xsl:text> salt</xsl:text><xsl:value-of select="@salt"/></xsl:if>
    </xsl:variable>
    <tr class="sub">
      <td class="sub-salt">
	<xsl:if test="@salt"><xsl:text>salt </xsl:text><xsl:value-of select="@salt"/></xsl:if>
      </td>
      <td class="sub-cp"><xsl:value-of select="@cp"/></td>
      <td class="sub-noto"><xsl:value-of select="@utf8"/></td>      
      <td class="sub-lak"><span class="ofs-lak{$salt}"><xsl:value-of select="@utf8"/></span></td>
      <td class="sub-svg"><img height="25px" src="{@svg}"/></td>
    </tr>
  </xsl:template>

  <xsl:template match="row">
    <tr class="row">
      <td/><td colspan="10" class="row-img"><img width="70%" src="{@src}"/></td>      
    </tr>
  </xsl:template>
  
</xsl:transform>
