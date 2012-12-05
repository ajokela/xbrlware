require File.dirname(__FILE__) + '/../../test_helper.rb'
class TestXmlParser < Test::Unit::TestCase

  def test_namespace_and_nsprefix_are_partof_attributes
    xml_content= %{
<?xml version="1.0" encoding="US-ASCII"?>
<xbrli:xbrl xmlns:xbrli="http://www.xbrl.org/2003/instance" xmlns:dei="http://xbrl.us/dei/2009-01-31"
            xmlns:iso4217="http://www.xbrl.org/2003/iso4217" xmlns:kr="http://www.kroger.com/20090815"
            xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:us-gaap="http://xbrl.us/us-gaap/2009-01-31"
            xmlns:xbrldi="http://xbrl.org/2006/xbrldi" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <link:schemaRef xlink:href="kr-20090815.xsd" xlink:type="simple"/>
    <xbrli:context id="I2007_CommonStockMember">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
            <xbrli:segment>
                <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">us-gaap:CommonStockMember
                </xbrldi:explicitMember>
            </xbrli:segment>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:instant>2008-02-02</xbrli:instant>
        </xbrli:period>
    </xbrli:context>
    <xbrli:context id="I2007_AdditionalPaidInCapitalMember">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
            <xbrli:segment>
                <xbrldi:explicitMember dimension="us-gaap:StatementEquityComponentsAxis">
                    us-gaap:AdditionalPaidInCapitalMember
                </xbrldi:explicitMember>
            </xbrli:segment>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:instant>2008-02-02</xbrli:instant>
        </xbrli:period>
    </xbrli:context>
    <xbrli:context id="D2009Q2YTD">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">0000056873</xbrli:identifier>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:startDate>2009-02-01</xbrli:startDate>
            <xbrli:endDate>2009-08-15</xbrli:endDate>
        </xbrli:period>
    </xbrli:context>
    <xbrli:unit id="USD">
        <xbrli:measure>iso4217:USD</xbrli:measure>
    </xbrli:unit>
    <xbrli:unit id="shares">
        <xbrli:measure>xbrli:shares</xbrli:measure>
    </xbrli:unit>
    <xbrli:unit id="USDPerShare">
        <xbrli:divide>
            <xbrli:unitNumerator>
                <xbrli:measure>iso4217:USD</xbrli:measure>
            </xbrli:unitNumerator>
            <xbrli:unitDenominator>
                <xbrli:measure>xbrli:shares</xbrli:measure>
            </xbrli:unitDenominator>
        </xbrli:divide>
    </xbrli:unit>
    <dei:EntityRegistrantName contextRef="D2009Q2YTD">THE KROGER CO.</dei:EntityRegistrantName>
    <dei:EntityCentralIndexKey contextRef="D2009Q2YTD">0000056873</dei:EntityCentralIndexKey>
    <us-gaap:StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest contextRef="I2007_CommonStockMember"
                                                                                    decimals="-6" unitRef="USD">
        947000000
    </us-gaap:StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest>
    <us-gaap:StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest
            contextRef="I2007_AdditionalPaidInCapitalMember" decimals="-6" unitRef="USD">3031000000
    </us-gaap:StockholdersEquityIncludingPortionAttributableToNoncontrollingInterest>

    <us-gaap:SharesIssued contextRef="I2007_CommonStockMember" decimals="-6" unitRef="shares">947000000
    </us-gaap:SharesIssued>
</xbrli:xbrl>    
    }

    _hash=Xbrlware::XmlParser.xml_in(xml_content, {'ForceContent' => true})
    assert("http://xbrl.us/us-gaap/2009-01-31", _hash["SharesIssued"][0]["nspace"]);
    assert("us-gaap", _hash["SharesIssued"][0]["nspace_prefix"]);

  end

  def test_xmslparser_is_faster_than_xmlsimple
    xml_content= %{
  <?xml version="1.0" encoding="us-ascii"?>
  <xbrl>
    <SeasonalityOfBusinessTextBlock contextRef="NineMonthsEnded_05Sep2009">
      &lt;!--DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" --&gt;
      &lt;!-- Begin Block Tagged Note 2 - bgllc:SeasonalityOfBusinessTextBlock--&gt;
      &lt;div style="font-family: 'Times New Roman',Times,serif"&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;b&gt;Note 2&amp;#8212;Seasonality of Business&lt;/b&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;The results for the third quarter are not necessarily indicative of the results that may be
      expected for the full year because sales of our products are seasonal. The seasonality of our
      operating results arises from higher sales in the second and third quarters versus the first and
      fourth quarters of the year, combined with the impact of fixed costs, such as depreciation and
      interest, which are not significantly impacted by business seasonality. From a cash flow
      perspective, the majority of our cash flow from operations is generated in the third and fourth
      quarters.
      &lt;/div&gt;
      &lt;/div&gt;
    </SeasonalityOfBusinessTextBlock>
    <AccountingChangesAndErrorCorrectionsTextBlock contextRef="NineMonthsEnded_05Sep2009">
      &lt;!--DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" --&gt;
      &lt;!-- Begin Block Tagged Note 3 - us-gaap:AccountingChangesAndErrorCorrectionsTextBlock--&gt;
      &lt;div style="font-family: 'Times New Roman',Times,serif"&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;b&gt;Note 3&amp;#8212;New Accounting Standards&lt;/b&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&lt;i&gt;SFAS No.&amp;#160;141(R) as amended&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In December&amp;#160;2007, the Financial Accounting Standards Board (&amp;#8220;FASB&amp;#8221;) issued Statement of
      Financial Accounting Standards (&amp;#8220;SFAS&amp;#8221;) No.&amp;#160;141(revised 2007), &amp;#8220;Business Combinations&amp;#8221; (&amp;#8220;SFAS
      141(R)&amp;#8221;), which addresses the accounting and disclosure for identifiable assets acquired,
      liabilities assumed, and noncontrolling interests in a business combination. In April&amp;#160;2009, the
      FASB issued FASB Staff Position No.&amp;#160;FAS 141(R)-1, &amp;#8220;Accounting for Assets Acquired and Liabilities
      Assumed in a Business Combination That Arise from Contingencies&amp;#8221; (&amp;#8220;FSP FAS 141(R)-1&amp;#8221;), which
      amended certain provisions of SFAS 141(R) related to the recognition, measurement, and disclosure
      of assets acquired and liabilities assumed in a business combination that arise from contingencies.
      SFAS 141(R) and FSP FAS 141(R)-1 became effective in 2009, and did not have a material impact on
      our Condensed Consolidated Financial Statements, but will continue to be evaluated on the outcome
      of future matters.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;SFAS No.&amp;#160;160&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In December&amp;#160;2007, the FASB issued SFAS No.&amp;#160;160, &amp;#8220;Noncontrolling Interests in Consolidated
      Financial Statements, an amendment of ARB No.&amp;#160;51&amp;#8221; (&amp;#8220;SFAS 160&amp;#8221;), which addresses the accounting and
      reporting framework for noncontrolling interests by a parent company. SFAS 160 also addresses
      disclosure requirements to distinguish between interests of the parent and interests of the
      noncontrolling owners of a subsidiary. SFAS 160 became effective in the first quarter of 2009.
      The provisions of SFAS 160 require that minority interest be renamed noncontrolling interests and
      that a company present a consolidated net income measure that includes the amount attributable to
      such noncontrolling interests for all periods presented. In addition, SFAS 160 requires reporting
      noncontrolling interests as a component of equity in our Condensed Consolidated Balance Sheets and
      below income tax expense in our Condensed Consolidated Statements of Operations. As required by
      SFAS 160, we have retrospectively applied the presentation to our prior year balances in our
      Condensed Consolidated Financial Statements.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;SFAS No.&amp;#160;161&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In March&amp;#160;2008, the FASB issued SFAS No.&amp;#160;161, &amp;#8220;Disclosures about Derivative Instruments and
      Hedging Activities, an amendment of FASB Statement No.&amp;#160;133&amp;#8221; (&amp;#8220;SFAS 161&amp;#8221;), which requires enhanced
      disclosures for derivative and hedging activities. SFAS 161 became effective in the first quarter
      of 2009. See Note 8 for required disclosure.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;FSP FAS 132(R)-1&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In December&amp;#160;2008, the FASB issued FASB Staff Position No.&amp;#160;SFAS 132(revised 2003)-1,
      &amp;#8220;Employers&amp;#8217; Disclosures about Postretirement Benefit Plan Assets&amp;#8221; (&amp;#8220;FSP FAS 132(R)-1&amp;#8221;), which
      requires employers to disclose information about fair value measurements of plan assets that are
      similar to the disclosures about fair value measurements required by SFAS No.&amp;#160;157, &amp;#8220;Fair Value
      Measurements&amp;#8221; (&amp;#8220;SFAS 157&amp;#8221;). FSP FAS 132(R)-1 will become effective for our annual financial
      statements for 2009. We are currently evaluating the impact of this standard on our Consolidated
      Financial Statements.
      &lt;/div&gt;
      &lt;!-- Folio --&gt;
      &lt;!-- /Folio --&gt;
      &lt;/div&gt;
      &lt;!-- PAGEBREAK --&gt;
      &lt;div style="font-family: 'Times New Roman',Times,serif"&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;FSP FAS 107-1 and APB 28-1&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In April&amp;#160;2009, the FASB issued FASB Staff Position No.&amp;#160;SFAS 107-1 and APB No.&amp;#160;28-1, &amp;#8220;Interim
      Disclosures about Fair Value of Financial Instruments&amp;#8221; (&amp;#8220;FSP FAS 107-1 and APB 28-1&amp;#8221;), which
      requires quarterly disclosure of information about the fair value of financial instruments within
      the scope of FASB Statement No.&amp;#160;107, &amp;#8220;Disclosures about Fair Value of Financial Instruments.&amp;#8221; FSP
      FAS 107-1 and APB 28-1 has an effective date requiring adoption by the third quarter of 2009 with
      early adoption permitted. We adopted the provisions of FSP FAS 107-1 and APB 28-1 in the first
      quarter of 2009. See Note 7 for required disclosures.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;SFAS No.&amp;#160;165&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In May&amp;#160;2009, the FASB issued SFAS No.&amp;#160;165, &amp;#8220;Subsequent Events&amp;#8221; (&amp;#8220;SFAS 165&amp;#8221;), which sets forth
      general standards of accounting for and disclosure of events that occur after the balance sheet
      date but before financial statements are issued or are available to be issued. SFAS 165 became
      effective in the third quarter of 2009 and did not have a material impact on our Consolidated
      Financial Statements.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;SFAS No.&amp;#160;167&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In June&amp;#160;2009, the FASB issued SFAS No.&amp;#160;167, &amp;#8220;Amendments to FASB Interpretation No.&amp;#160;46(R)&amp;#8221;
      (&amp;#8220;SFAS 167&amp;#8221;), which amends FASB Interpretation No.&amp;#160;46(revised December&amp;#160;2003) to address the
      elimination of the concept of a qualifying special purpose entity. SFAS 167 also replaces the
      quantitative-based risks and rewards calculation for determining which enterprise has a controlling
      financial interest in a variable interest entity with an approach focused on identifying which
      enterprise has the power to direct the activities of a variable interest entity and the obligation
      to absorb losses of the entity or the right to receive benefits from the entity. Additionally,
      SFAS 167 provides more timely and useful information about an enterprise&amp;#8217;s involvement with a
      variable interest entity. SFAS 167 will become effective in the first quarter of 2010. We are
      currently evaluating the impact of this standard on our Consolidated Financial Statements.
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 12pt"&gt;&lt;i&gt;SFAS No.&amp;#160;168&lt;/i&gt;
      &lt;/div&gt;
      &lt;div align="left" style="font-size: 10pt; margin-top: 6pt"&gt;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;In June&amp;#160;2009, the FASB issued SFAS No.&amp;#160;168, &amp;#8220;The &lt;i&gt;FASB Accounting Standards
      Codification&lt;/i&gt;&lt;sup style="font-size: 85%; vertical-align: text-top"&gt;TM&lt;/sup&gt; and the Hierarchy of Generally Accepted Accounting Principles, a
      replacement of FASB Statement No.&amp;#160;162&amp;#8221; (&amp;#8220;SFAS 168&amp;#8221;), which establishes the FASB Accounting
      Standards Codification as the source of authoritative accounting principles recognized by the FASB
      to be applied in the preparation of financial statements in conformity with generally accepted
      accounting principles. SFAS 168 explicitly recognizes rules and interpretive releases of the
      Securities and Exchange Commission (&amp;#8220;SEC&amp;#8221;) under federal securities laws as authoritative GAAP for
      SEC registrants. SFAS 168 will become effective in the fourth quarter of 2009 and will require the
      Company to update all existing GAAP references to the new codification references for all future
      filings.
      &lt;/div&gt;
      &lt;/div&gt;
    </AccountingChangesAndErrorCorrectionsTextBlock>
  </xbrl>  
  }

    m_xml_simple=Benchmark.measure do
      XmlSimple.xml_in(xml_content, {'ForceContent' => true})
    end

    m_xml_parser=Benchmark.measure do
      Xbrlware::XmlParser.xml_in(xml_content, {'ForceContent' => true})
    end

    assert(m_xml_parser.real < m_xml_simple.real)

    $LOG.debug "XmlParser is " + (m_xml_simple.real/m_xml_parser.real).to_s + " faster as entity replacement is ignored"

  end
end