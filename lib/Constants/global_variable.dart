

import 'package:flutter/cupertino.dart';

double totalProgress = 27;
double currentProgress = 0.0;
List<String> ageGroup = [
  'Under 18',
  '18-30',
  '31-50',
  '51+'
];
List<String> readingFrequencies = [
  'Daily',
  'Few times a week',
  'Occasionally',
  'Rarely/Never',
];
List<String> studyGroup = [
  'Yes',
  'Occasionally',
  'No'
];

List<String> spiritualStages = [
  'Seeking',
  'Mature',
  'Growing',
  'Reconnecting',
  'Exploring',
];


List<String> churchGoingFrequencies = [
  'Weekly',
  'Monthly',
  'Occasionally',
  'Rarely',
];

PageController controller = PageController();

bool denominationIsSelected = false;
bool ageIsSelected = false;
bool attendChurchIsSelected = false;
bool meditateIsSelected = false;
bool studyGroupIsSelected = false;
bool journeyIsSelected = false;
bool ignorePages = true;
bool bibleVersionIsSelected = false;

ValueNotifier<bool> isSelected = ValueNotifier(false);
//Strings

String onboarding2String = "What is your Denomination?";
String onboarding4String = "What is your Age\ngroup?";
String onboarding6String = "Which Bible version speaks to you most";
String onboarding7String = "*80% of users aged under 18y found\nrenewed hope through daily engagement.";
String onboarding8String = "How often do you\nattend church?";
String onboarding10String = "How often do you pray or meditate?";
String onboarding12String = "Do you participate in Bible study groups?";
String onboarding14String = "Where are you in your  spiritual journey?";
String onboarding16String = "Scripture Shapes You";
String onboarding16String2 = "A few verses a day can shift your mindset, build\nclarity, and guide your path forward.";
String onboarding17String = "90% report deeper\nspiritual understanding\n—join their ranks.";
String onboarding18String = "Scripture in Your\nRoutine";
String onboarding19String = "Real people. Real change.";
String onboarding18String2 = "Small moments matter—read during coffee, your\ncommute, or quick breaks to stay spiritually\ngrounded.";
String onboarding19String2 = "Daily scripture helped them grow—and your story\ncould be next.";
String onboarding20String = "Wisdom That\nEndures";
String onboarding20String2 = "The faith and choices of biblical figures still\necho today—offering clarity, courage, and\ntruth for modern life.";
String onboarding21String = "Rooted in Wisdom";
String onboarding21String2 = "You’re part of something bigger.\nJoin thousands who draw strength from a\nlegacy that spans generations.";
