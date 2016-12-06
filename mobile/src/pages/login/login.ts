import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { GooglePlus } from 'ionic-native';

@Component({
  selector: 'page-login',
  templateUrl: 'login.html'
})
export class LoginPage {
  public userData;

  loginUser() {
    GooglePlus.login({
      'scopes': 'profile email',
      'webClientId':
      '963435957128-giebqu5jsjjc3972lpe94e9mvvaurhhr.apps.googleusercontent.com'
    })
    .then(
      (res) => {
        console.log('good');
        this.userData = res;
      },
      (err) => {
        console.log('Error: ' + err);
      }
    )
  }

  constructor(public navCtrl: NavController) {

  }
  
}
