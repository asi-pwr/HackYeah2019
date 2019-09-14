import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/common/bloc/login_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this._loginBloc, {Key key, this.title}) : super(key: key);

  final LoginBloc _loginBloc;
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseUser _user;
  // If this._busy=true, the buttons are not clickable. This is to avoid
  // clicking buttons while a previous onTap function is not finished.
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    widget._loginBloc.firebaseAuth.currentUser().then(
          (user) => setState(() => this._user = user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(_user == null
          ? 'You are not logged in.'
          : 'You are logged in as "${_user.displayName}".'),
    );

    final googleLoginBtn = MaterialButton(
      color: Colors.blueAccent,
      child: Text('Log in with Google'),
      onPressed: this._busy
          ? null
          : () async {
        setState(() => this._busy = true);
        await this._googleSignIn();
        widget._loginBloc.saveUserData(_user);
        Navigator.pop(context);
        setState(() => this._busy = false);
      },
    );

    final currentUserBtn = MaterialButton(
        color: Colors.grey,
        child: Text('My account'),
        onPressed: () => this._showUserProfilePage(this._user)
    );

    final signOutBtn = FlatButton(
      child: Text('Log out'),
      onPressed: this._busy
          ? null
          : () async {
        setState(() => this._busy = true);
        await this._signOut();
        setState(() => this._busy = false);
      },
    );

    var widgetsList = _user == null
        ? <Widget>[
          statusText,
          googleLoginBtn,
          signOutBtn
        ] : <Widget>[
          statusText,
          googleLoginBtn,
          currentUserBtn,
          signOutBtn
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
          children: widgetsList
        ),
      ),
    );
  }

  // Sign in with Google.
  Future<FirebaseUser> _googleSignIn() async {
    final curUser = this._user ?? await widget._loginBloc.firebaseAuth.currentUser();
    if (curUser != null && !curUser.isAnonymous) {
      return curUser;
    }
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
    final user = await widget._loginBloc.firebaseAuth.signInWithCredential(credential);
    setState(() => this._user = user.user);
    return user.user;
  }

  Future<Null> _signOut() async {
    widget._loginBloc.firebaseAuth..signOut();
    setState(() => this._user = null);
  }

  // Show user's profile in a new screen.
  void _showUserProfilePage(FirebaseUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text('user profile'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(title: Text('User id: ${user.uid}')),
              ListTile(title: Text('Display name: ${user.displayName}')),
              ListTile(title: Text('Anonymous: ${user.isAnonymous}')),
              ListTile(title: Text('providerId: ${user.providerId}')),
              ListTile(title: Text('Email: ${user.email}')),
              ListTile(
                title: Text('Profile photo: '),
                trailing: user.photoUrl != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                )
                    : CircleAvatar(
                  child: Text(user.displayName[0]),
                ),
              ),
              ListTile(
                title: Text(
                    'Last sign in: ${DateTime.fromMillisecondsSinceEpoch(user.metadata.lastSignInTime.millisecondsSinceEpoch)}'),
              ),
              ListTile(
                title: Text(
                    'Creation time: ${DateTime.fromMillisecondsSinceEpoch(user.metadata.creationTime.millisecondsSinceEpoch)}'),
              ),
              ListTile(title: Text('ProviderData: ${user.providerData}')),
            ],
          ),
        ),
      ),
    );
  }
}
