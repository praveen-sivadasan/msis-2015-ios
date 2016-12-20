# Objective-C

Software : XCode 7.3.1
Language : Objective C

API's integrated : Back4App, MessageUI.framework, Google Sign-In for iOS, FSLineChart, JSBadgeView, Bug life - reporting bugs.

This project is named as edConnect which means educational connect, for students and teachers to have an efficient communication with each other. This application was designed as a prototype to introduce a mobile based application for students and faculties in a university to manage their courses easily from anywhere across the globe in a user friendly manner.
The application edConnect lets 3 kinds of users to log into the system. Admin being the super user has special powers to overlook the other application users and their actions.

The Admin user has been added already into the user with a google account. The application requires the user to have a valid Gmail account In order to create an account. This functionality has been achieved by integrating edConnect with GoogleSignIn framework.
The following are the main responsibilities the admin can perform in edConnect:
1. Course creation:
An admin can add a course into the system by giving the necessary details like name, start date of course and capacity of the class. Admin can also attach an image to depict the course.
2. Removing a course:
The Admin can remove a course which has been added into the system. The removal of the course can further remove the instructor from the teaching position and all the students enrolled into the course.
3. Updating basic user information
The admin can update the basic information of various users including students and faculties. 
4. Approving Requests
Student can enroll into a course only once the user request has been approved by the admin. Similarly a faculty can only teach a course once the faculty has been approved by the admin.
The admin can either choose to approve or reject the user request considering various factors.
5. View students enrolled to a course
The admin can also see the list of students enrolled to a particular course and update the grades provided by the faculty. The application also provides a chart representation of all students enrolled to a particular course.

For a student to login in to the application, he/she has to use their Gmail credentials to create an account. Once the user logs in, he/she can see the various available courses. The user can request the admin for enrollment. But if the capacity of the course is already full then the system will prevent the user from raising a request.
The following are the main responsibilities the student can perform in edConnect:
1. View and register for courses
If the available course has seats left, the system will then allow the user to raise a request to enroll into the subject.
2. View enrolled courses
The students can also see list of courses he/she has applied to and the status of the requests. In case of an approved requests the user can further see the grades obtained in the course.
3. View all other students and faculties
The user can also browse through rest of students and faculties and obtain their basic information including email address for communication purpose.

All the teaching assistants can create edConnect profile similar to a student with the use of a Gmail account. Once account profile is set user lands on the homepage and has the following available options:
1. View and register for courses
The user can go through list of available courses and raise a request for a course if its available for taking. Once the admin approves the request the faculty will be linked to the subject and can start viewing enrolled students. 
2. View enrolled courses
The students can also see list of courses he/she has applied to and the status of the requests. In case of an approved requests the user can further see the grades obtained in the course.
3. View all other students and faculties
The user can also browse through rest of students and faculties and obtain their basic information including email address for communication purpose. The user can also update one’s own profile information.
