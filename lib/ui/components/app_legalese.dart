import 'package:flutter/material.dart';

/// TERMS AND CONDITIONS

final _headingOfTerms = "Dot.Studios LLC Terms of Service";

final _termsHeading = "1. Terms";

final _termsText =
    "By accessing our app, JustSplit, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing JustSplit. The materials contained in JustSplit are protected by applicable copyright and trademark law.";

final _useLicensesHeading = "2. Use License";

final _useLicensesText = """
a. Permission is granted to temporarily download one copy of JustSplit per device for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:

  \t\t\ti. modify or copy the materials;
  \t\t\tii. use the materials for any commercial purpose, or for any public display (commercial or non-commercial);
  \t\t\tiii. attempt to decompile or reverse engineer any software contained in JustSplit;
  \t\t\tiv. remove any copyright or other proprietary notations from the materials; or
  \t\t\tv. transfer the materials to another person or "mirror" the materials on any other server.

b. This license shall automatically terminate if you violate any of these restrictions and may be terminated by Dot.Studios LLC at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.
""";

final _disclaimerHeading = "3. Disclaimer";

final _disclaimerText = """
a. The materials within JustSplit are provided on an 'as is' basis. Dot.Studios LLC makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.\n
b. Further, Dot.Studios LLC does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to JustSplit.
""";

final _limitationsHeading = "4. Limitations";

final _limitationText =
    """In no event shall Dot.Studios LLC or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use JustSplit, even if Dot.Studios LLC or a Dot.Studios LLC authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.""";

final _accuracyOMHeading = "5. Accuracy of materials";

final _accuracyOMText =
    """The materials appearing in JustSplit could include technical, typographical, or photographic errors. Dot.Studios LLC does not warrant that any of the materials on JustSplit are accurate, complete or current. Dot.Studios LLC may make changes to the materials contained in JustSplit at any time without notice. However Dot.Studios LLC does not make any commitment to update the materials.""";

final _linksHeading = "6. Links";

final _linksText =
    """Dot.Studios LLC has not reviewed all of the sites linked to its app and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Dot.Studios LLC of the site. Use of any such linked website is at the user's own risk.""";

final _modificationsHead = "7. Modifications";

final _modificationText =
    """Dot.Studios LLC may revise these terms of service for its app at any time without notice. By using JustSplit you are agreeing to be bound by the then current version of these terms of service.""";

final _governingLHeading = "8. Governing Law";

final _governingLText =
    """These terms and conditions are governed by and construed in accordance with the laws of India and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.""";

/// PRIVACY POLICY

final _privacyPolicyHeading = "Privacy Policy";

final _privacyPolicyText = """
Your privacy is important to us. It is Dot.Studios LLC' policy to respect your privacy regarding any information we may collect from you through our app, JustSplit.\n
We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\n
We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n
We don’t share any personally identifying information publicly or with third-parties, except when required to by law.\n
Our app may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.\n
You are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.\n
Your continued use of our app will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.\n
This policy is effective as of 29 August 2020.\n
""";

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _titleStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );
    final _headingStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.0);
    final _bodyStyle =
        Theme.of(context).textTheme.caption.copyWith(fontSize: 12.0);
    final _verticalSpacer = 18.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_headingOfTerms, style: _titleStyle),
        SizedBox(height: _verticalSpacer),
        Text(_termsHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_termsText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_useLicensesHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_useLicensesText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_disclaimerHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_disclaimerText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_limitationsHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_limitationText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_accuracyOMHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_accuracyOMText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_linksHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_linksText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_modificationsHead, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_modificationText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        Text(_governingLHeading, style: _headingStyle),
        SizedBox(height: _verticalSpacer),
        Text(_governingLText, style: _bodyStyle),
        SizedBox(height: _verticalSpacer),
        SizedBox(height: _verticalSpacer),
        Text(_privacyPolicyHeading, style: _titleStyle),
        SizedBox(height: _verticalSpacer),
        Text(_privacyPolicyText, style: _bodyStyle),
      ],
    );
  }
}
