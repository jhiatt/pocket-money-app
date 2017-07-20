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
      currentCash: 0,
      editExpense: 0,
      pmPercentage: "50%",
      // stringify
    },
    mounted: function() {
      var that = this;
      that.accountID = document.getElementById("currentUser").value;
      $.get('/api/v1/accounts/' + that.accountID + '.json', function(result) {
        console.log(result);
        that.account = result;
        that.pocketMoney = parseInt(result.pocket_money);
        console.log(that.account);
        $.get('/api/v1/users/' + that.account.user_id + '/tags', function(result) {
          that.tags = result;
          console.log(that.tags);
        });
        $.get('api/v1/users/' + that.account.user_id + '/expenses', function(result) {
          that.expenses = result;
          console.log(that.expenses);
        });
        $.get('api/v1/users/' + that.account.user_id + '/events', function(result) {
          that.events = result;
        });
        // that.calculateCurrentCash();
        // that.sortExpenses();
      });
    },
    methods: {
      updateAccount: function() {
        var that = this;
        var params = {last_balance: that.lastBalance, pocket_time: that.pocketTime};
        $.ajax({
          url: '/api/v1/accounts/' + that.accountID + '/edit.json',
          type: 'PATCH',
          data: params,
          success: function(result) {
            that.account = result;
          }
        }.bind(this));
      },  
      addExpense: function(amount, tagID, impact) {
        var that = this;
        var params = {amount: amount, tag_id: tagID, user_id: that.account.user_id, date: new Date(), impact: impact};
        $.post('/api/v1/expenses', params, function(result) {
          that.newExpense = result;
          that.account = result.account;
          that.pocketMoney += parseInt(amount);
          that.newExpAmount = null;
          that.expenses.unshift(that.newExpense);
        }.bind(this));
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
      },
      calculateCurrentCash: function() {
        var total = this.lastBalance;
        
        for (var i = 0; i > this.expenses.length; i++) {
          total += this.expenses[i];
        }

        for (var j = 0; j > this.events.length; i++) {
          total += this.events[j];
        }
      },
      sortExpenses: function() {

        this.expenses.sort(function(expense1, expense2) {
          // if false flips the order
          return expense1.date > expense2.date;
        });
      },
      deleteExpense: function(id) {
        $.ajax({
          url: '/api/v1/expenses/' + id + '/delete.json',
          type: 'DELETE',
          success: function(result) {
            this.expenses = result;
          }
        }.bind(this));
      },
      editExpense: function(id) {
        var params = {amount: this.editExpenseAmount, tag_id: this.editTagId};
        $.ajax({
          url: '/api/v1/expenses/' + id + '/edit.json',
          type: 'PATCH',
          data: params,
          success: function(result) {
            this.editExpense = result;
          }
        });
      },
    }
  });
});

