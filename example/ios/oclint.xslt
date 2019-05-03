<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <!-- <pmd version="oclint-0.13"> -->
      <!-- <xsl:for-each select="pmd"> -->
        <!-- <xsl:value-of select="*"/> -->
        <!-- <xsl:if test="violation/@ruleset = clang"> -->
            <!-- <xsl:value-of select="."/> -->
            <xsl:apply-templates />
        <!-- </xsl:if> -->
      <!-- </xsl:for-each> -->
    <!-- </pmd> -->
  </xsl:template>
  <!-- <xsl:template match="file">
    <xsl:if test="violation[not(violation/@ruleset = 'clang')">
        <xsl:copy-of select="."/>
    </xsl:if>
</xsl:template> -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- override the above template for certain Learner elements; output nothing. -->
  <xsl:template match="file[
     (violation/@ruleset = 'clang')]">
     <!-- <xsl:copy-of select="."/> -->
  </xsl:template>

</xsl:stylesheet>
