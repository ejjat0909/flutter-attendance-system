class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to Attendance Keeper",
    image: "assets/images/image1.png",
    desc: "Remember to keep track of your attendance professionally",
  ),
  OnboardingContents(
    title: "Effortlessly Track Your Attendance",
    image: "assets/images/image2.png",
    desc:
        "Track the attendance like a boss",
  ),
  OnboardingContents(
    title: "Maximize Your Time with Attendance Manager",
    image: "assets/images/image3.png",
    desc:
        "Get More Time for Fun Stuff with Attendance Manager",
  ),
];