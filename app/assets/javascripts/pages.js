/* global Vue */
/* global $ */

document.addEventListener("DOMContentLoaded", function(event) { 
  var app = new Vue({
    el: '#app',
    data: {
      tags: [],
      expenses: [],
      pocketMoney: 0,
      amount: 0,
      accountID: "",
      account: '',
      lastBalance: null,
      pocketTime: 0,
      newExpense: {},
      newExpAmount: 0,
      newExpImpact: "Out",
      tagID: null,
      newTagForm: false,
      newTagDescription: "",
    },
    mounted: function() {
      var that = this;
      that.accountID = document.getElementById("currentUser").value;
      $.get('/api/v1/accounts/' + that.accountID + '.json', function(result) {
        console.log(result);
        that.account = result;
        console.log(that.account);
        $.get('/api/v1/users/' + that.account.user_id + '/tags', function(result) {
          that.tags = result;
          console.log(that.tags);
        });
        $.get('api/v1/users/' + that.account.user_id + '/expenses', function(result) {
          that.expenses = result;
          console.log(that.expenses);
        });
      });
    },
    methods: {
      updateAccount: function() {
        var params = {last_balance: this.lastBalance, pocket_time: this.pocketTime};
        $.ajax({
          url: '/api/v1/accounts/' + this.accountID + '/edit.json',
          type: 'PATCH',
          data: params,
          success: function(result) {
            this.account = result;
          }
        }.bind(this));
      },  
      addExpense: function(amount, tagID, impact) {
        var that = this;
        var params = {amount: amount, tag_id: tagID, user_id: this.account.user_id, date: new Date(), impact: impact};
        $.post('/api/v1/expenses/new', params, function(result) {
          this.newExpense = result;
          this.account = result.account;
        }.bind(this));
        this.pocketMoney += this.newExpAmount;
        this.newExpAmount = null;
        this.expenses.unshift(this.newExpense);
      },
      addNewTag: function(description) {
        var params = {description: description, user_id: this.account.user_id};
        $.post('/api/v1/tags', params, function(result) {
          this.tags.push(result);
          this.tagAccount = result.account;
        }.bind(this));
        this.newTagDescription = null;
        console.log(this.tags);
      },
      newTag: function() {
        this.newTagForm = !this.newTagForm;
        return this.newTagForm;
      }

    }
  });
});


// class PagesController < ApplicationController
//   before_action :authenticate_user!

//   #before action: check to see if roll forward is needed (maybe at the calendar too?)
//     #popup also lets you know it will be less frequent if you extend pocket time
//   def index
//     current_user.account.check_pocket_period
//     @expense = Expense.new(date: Time.now)
//     if current_user && current_user.tags.any?
//       @tags = Tag.where(user_id: current_user.id)
//       current_user.account.pocket_money_update
//     elsif current_user
//       @tags = []
//     else
//       redirect_to "/users/sign_in"
//     end
//   end

// end