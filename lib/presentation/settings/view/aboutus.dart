// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';

class ConstColor {
  static const Color black = Color(0xFF121212);
  static const Color darkGold = Color(0xFFC89B3C);
  static const Color gold = Color(0xFFb8964c);
  static const Color white = Color(0xFFF5F5F7);
  static const Color darkGray = Color(0xFF2A2A2A);
  static const Color lightGray = Color(0xFF3D3D3D);
}

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return OWPScaffold(
      title: 'About Us',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(screenWidth, screenHeight),
            _buildStatsSection(screenWidth),
            _buildWhyChooseUsSection(screenWidth),
            _buildVisionMissionSection(screenWidth),
            _buildTeamSection(screenWidth),
            _buildFooterSection(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ConstColor.darkGold.withOpacity(0.15), ConstColor.black],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your IT Success\nPartner',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w700,
                  color: ConstColor.gold,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'In today\'s business climate, every minute counts. Managing your IT services can be time consuming and often frustrating. With our winning IT solutions, Great Way Company is here to help.',
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  color: ConstColor.white.withOpacity(0.9),
                  height: 1.6,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We\'ll provide your organization with all the IT services that you need - so you have the peace of mind to focus on the rest of your business.',
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  color: ConstColor.white.withOpacity(0.9),
                  height: 1.6,
                ),
              ),
              SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ConstColor.darkGold.withOpacity(0.2),
                      ConstColor.gold.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ConstColor.gold.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technology is the foundation; innovation is the journey.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                        color: ConstColor.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          color: ConstColor.white.withOpacity(0.9),
                        ),
                        children: [
                          TextSpan(text: 'At '),
                          TextSpan(
                            text: 'Onset Way',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ConstColor.gold,
                            ),
                          ),
                          TextSpan(text: ' we build both.'),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Empowering your vision with cutting-edge solutions crafted for tomorrow\'s challenges.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: ConstColor.white.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.1,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ConstColor.darkGray, ConstColor.black],
        ),
      ),
      child: screenWidth > 600
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('4', 'Branches', screenWidth),
                _buildStatItem('1000+', 'Clients', screenWidth),
                _buildStatItem('15+', 'Services', screenWidth),
                _buildStatItem('100+', 'Projects\nDelivered', screenWidth),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('4', 'Branches', screenWidth),
                    _buildStatItem('1000+', 'Clients', screenWidth),
                  ],
                ),
                SizedBox(height: screenWidth * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('15+', 'Services', screenWidth),
                    _buildStatItem('100+', 'Projects\nDelivered', screenWidth),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String number, String label, double screenWidth) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: screenWidth * 0.09,
            fontWeight: FontWeight.w700,
            color: ConstColor.gold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
            color: ConstColor.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWhyChooseUsSection(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ConstColor.black, ConstColor.darkGray],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHY CHOOSE US',
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              fontWeight: FontWeight.w600,
              color: ConstColor.gold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          Text(
            'Why Choose Us',
            style: TextStyle(
              fontSize: screenWidth * 0.075,
              fontWeight: FontWeight.w700,
              color: ConstColor.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'We bring tailored IT solutions that drive business success through innovation, reliability, and expertise.',
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              color: ConstColor.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Our dedicated team combines cutting-edge technology with strategic thinking to deliver exceptional results that exceed expectations.',
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              color: ConstColor.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
          SizedBox(height: 32),
          screenWidth > 600
              ? GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenWidth * 0.04,
                  children: [
                    _buildFeatureCard(
                      'Fast Implementation',
                      'Get your IT solutions up and running quickly with our streamlined deployment process and expert technical team.',
                      Icons.rocket_launch,
                      screenWidth,
                    ),
                    _buildFeatureCard(
                      'Smartly Execute',
                      'Strategic approach to IT consulting that delivers measurable results and drives business growth efficiently.',
                      Icons.auto_awesome,
                      screenWidth,
                    ),
                    _buildFeatureCard(
                      'Carefully Planned',
                      'Every project is meticulously planned with detailed roadmaps, risk assessments, and milestone tracking.',
                      Icons.assignment_turned_in,
                      screenWidth,
                    ),
                    _buildFeatureCard(
                      'Perfect Design',
                      'User-centric design approach that creates intuitive interfaces and seamless user experiences.',
                      Icons.design_services,
                      screenWidth,
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildFeatureCard(
                      'Fast Implementation',
                      'Get your IT solutions up and running quickly with our streamlined deployment process and expert technical team.',
                      Icons.rocket_launch,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    _buildFeatureCard(
                      'Smartly Execute',
                      'Strategic approach to IT consulting that delivers measurable results and drives business growth efficiently.',
                      Icons.auto_awesome,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    _buildFeatureCard(
                      'Carefully Planned',
                      'Every project is meticulously planned with detailed roadmaps, risk assessments, and milestone tracking.',
                      Icons.assignment_turned_in,
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    _buildFeatureCard(
                      'Perfect Design',
                      'User-centric design approach that creates intuitive interfaces and seamless user experiences.',
                      Icons.design_services,
                      screenWidth,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    double screenWidth,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: ConstColor.lightGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: ConstColor.gold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ConstColor.gold, size: screenWidth * 0.07),
          ),
          SizedBox(height: screenWidth * 0.04),
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.048,
              fontWeight: FontWeight.w600,
              color: ConstColor.white,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Text(
            description,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: ConstColor.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionMissionSection(double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ConstColor.darkGray, ConstColor.black],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          children: [
            _buildVisionCard(screenWidth),
            SizedBox(height: screenWidth * 0.08),
            _buildMissionCard(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionCard(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.06),
      decoration: BoxDecoration(
        color: ConstColor.lightGray,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: screenWidth * 0.14,
                height: screenWidth * 0.14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ConstColor.darkGold, ConstColor.gold],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.visibility,
                    color: ConstColor.white,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VISION STATEMENT',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w600,
                        color: ConstColor.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Our Vision',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w700,
                        color: ConstColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.06),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                color: ConstColor.white.withOpacity(0.9),
                height: 1.6,
              ),
              children: [
                TextSpan(text: 'At '),
                TextSpan(
                  text: 'Onset Way',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ConstColor.gold,
                  ),
                ),
                TextSpan(
                  text:
                      ', our vision is to empower businesses through innovative IT solutions that drive growth, enhance efficiency, and foster long-term success.\n\nWe strive to be a trusted partner, delivering cutting-edge technology and exceptional service that simplifies complex challenges and enables our clients to reach their full potential in a digital-first world.',
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ConstColor.gold.withOpacity(0.3)),
            ),
            child: Text(
              '"Shaping the future through smart, secure, and sustainable tech"',
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                fontStyle: FontStyle.italic,
                color: ConstColor.gold,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.09),
      decoration: BoxDecoration(
        color: ConstColor.lightGray,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: screenWidth * 0.14,
                height: screenWidth * 0.14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ConstColor.darkGold, ConstColor.gold],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.flag,
                    color: ConstColor.white,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MISSION STATEMENT',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w600,
                        color: ConstColor.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w700,
                        color: ConstColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.06),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                color: ConstColor.white.withOpacity(0.9),
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: 'Onset Way',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ConstColor.gold,
                  ),
                ),
                TextSpan(
                  text:
                      ' is dedicated to providing tailored IT solutions that meet the unique needs of each client.\n\nWe leverage advanced technology, expert insights, and a customer-centric approach to deliver reliable, scalable, and efficient services.\n\nOur mission is to help businesses optimize operations, drive innovation, and achieve sustainable growth in an ever-evolving digital landscape.',
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            childAspectRatio: screenWidth > 600 ? 2.2 : 1.8,
            crossAxisSpacing: (screenWidth * 0.04).clamp(16.0, 24.0),
            mainAxisSpacing: (screenWidth * 0.04).clamp(16.0, 24.0),
            children: [
              _buildMissionPoint(
                '1',
                'Tailored Solutions',
                'Custom IT Services',
                screenWidth,
              ),
              _buildMissionPoint(
                '2',
                'Expert Insights',
                'Advanced Technology',
                screenWidth,
              ),
              _buildMissionPoint(
                '3',
                'Customer-Centric',
                'Reliable & Scalable',
                screenWidth,
              ),
              _buildMissionPoint(
                '4',
                'Growth Focused',
                'Digital Innovation',
                screenWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionPoint(
    String number,
    String title,
    String subtitle,
    double screenWidth,
  ) {
    // Calculate responsive sizes with minimum values to prevent pixelation
    double containerSize = (screenWidth * 0.08).clamp(36.0, 48.0);
    double borderRadius = containerSize / 2;
    double fontSizeNumber = (screenWidth * 0.035).clamp(14.0, 18.0);
    double fontSizeTitle = (screenWidth * 0.038).clamp(14.0, 18.0);
    double fontSizeSubtitle = (screenWidth * 0.032).clamp(12.0, 16.0);
    double padding = (screenWidth * 0.04).clamp(16.0, 24.0);
    double spacing = (screenWidth * 0.025).clamp(8.0, 12.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: ConstColor.darkGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ConstColor.gold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  color: ConstColor.gold,
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: ConstColor.gold.withOpacity(0.4),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      color: ConstColor.white,
                      fontSize: fontSizeNumber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: (screenWidth * 0.03).clamp(12.0, 16.0)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: ConstColor.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: fontSizeSubtitle,
              color: ConstColor.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ConstColor.black, ConstColor.darkGray],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Onset Way Team',
            style: TextStyle(
              fontSize: screenWidth * 0.075,
              fontWeight: FontWeight.w700,
              color: ConstColor.white,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Text(
            'Innovation Leaders',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: ConstColor.gold,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.06),
            decoration: BoxDecoration(
              color: ConstColor.lightGray,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ConstColor.gold.withOpacity(0.3)),
            ),
            child: Text(
              '"Driven by innovation. Powered by trust. Our mission is to transform the way businesses interact with technology — securely, smartly, and sustainably."',
              style: TextStyle(
                fontSize: screenWidth * 0.042,
                fontStyle: FontStyle.italic,
                color: ConstColor.white.withOpacity(0.9),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ConstColor.darkGray, ConstColor.black],
        ),
      ),
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                color: ConstColor.gold,
                size: screenWidth * 0.07,
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                '24/7 Support Available',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: ConstColor.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
