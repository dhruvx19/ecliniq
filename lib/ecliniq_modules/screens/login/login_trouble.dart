import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginTroublePage extends StatelessWidget {
  const LoginTroublePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EcliniqScaffold(
      backgroundColor: EcliniqScaffold.primaryBlue,
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 52),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: SvgPicture.asset(
                    EcliniqIcons.close.assetPath,
                    width: 32,
                    height: 32,
                  ),
                ),

         
              ],
            ),

           

            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need help logging in?',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff424242),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Try the following',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ).copyWith(color: Color(0xff424242)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),
                      Row(
                        children: [
                          SvgPicture.asset(
                            EcliniqIcons.questionCircle.assetPath,
                            width: 32,
                            height: 32,
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trouble in Sign?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xff424242),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Go to our help centre to know step - by - step guide for sign in or sign-up process',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff8E8E8E),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // Your onPressed logic here
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F7FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xff96BFFF),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Go to Help Centre',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff2372EC),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Color(0xff2372EC),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Divider(thickness: 1),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                           SvgPicture.asset(
                            EcliniqIcons.chatMessage.assetPath,
                            width: 32,
                            height: 32,
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Can’t sign in?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xff424242),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Get instant answers to your queries from our support team',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff8E8E8E),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // Your onPressed logic here
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F7FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xff96BFFF),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Contact Customer Support',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff2372EC),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Color(0xff2372EC),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      //   const Divider(thickness: 1),
                      //   const SizedBox(height: 26),
                      //   Row(
                      //     children: [
                      //       Container(
                      //         width: 32,
                      //         height: 32,
                      //         decoration: BoxDecoration(
                      //           color: Colors.blue.shade50,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         child: Image.asset(
                      //           "lib/ecliniq_icons/assets/Vector_msg.png",
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      //   const SizedBox(height: 6),
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Already have an account?',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           fontSize: 18,
                      //           color: Colors.grey.shade900,
                      //           fontFamily: 'Inter',
                      //         ),
                      //       ),
                      //       const SizedBox(height: 5),
                      //       Text(
                      //         'You can sign in with your registered email id and password',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 14,
                      //           color: Colors.grey.shade600,
                      //           fontFamily: 'Inter',
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      //   const SizedBox(height: 10),
                      //   Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: ElevatedButton.icon(
                      //       onPressed: () {},
                      //       icon: const SizedBox.shrink(),
                      //       label: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: const [
                      //           Text(
                      //             'Sign in with email',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 14,
                      //               color: Colors.blue,
                      //               fontFamily: 'Inter',
                      //             ),
                      //           ),
                      //           SizedBox(width: 8),
                      //           Icon(
                      //             Icons.arrow_forward,
                      //             size: 18,
                      //             color: Colors.blue,
                      //           ),
                      //         ],
                      //       ),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.blue.shade50,
                      //         foregroundColor: Colors.blue.shade100,
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 16,
                      //           vertical: 12,
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //           side: BorderSide(color: Colors.blue, width: 0.5),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
