/* global Vue */
/* global $ */

document.addEventListener("DOMContentLoaded", function(event) { 
  var app = new Vue({
    el: '#app',
    data: {
      // arrays
      tags: [],
      expenses: [],
      accountID: "",
      tagID: null,
      account: '',
      // for api
      amount: 0,
      newExpense: {},
      newExpAmount: null,
      newExpImpact: "Out",
      editExpense: 0,
      newTagForm: false,
      newTagDescription: "",
      // calculators
      pocketMoney: 0,
      lastBalance: 0,
      currentBalance: 0,
      pocketTime: 0,
      pmPercentage: "50%",
      userId: 0,
      hideExpenseForm: false,
      accountUpdateForm: false,
      // stringify

    },
    mounted: function() {
      var that = this;
      that.accountID = document.getElementById("currentUser").value;
      $.get('/api/v1/accounts/' + that.accountID + '.json', function(result) {
        console.log(result);
        that.account = result;
        that.userId = result.user_id;
        that.pocketMoney = parseInt(result.pocket_money);
        that.lastBalance = that.account.last_balance;
        console.log(that.account);
        $.get('api/v1/users/' + that.account.user_id + '/expenses', function(result) {
          that.expenses = result;
          console.log(that.expenses);
          that.sortExpenses();
          $.get('api/v1/users/' + that.account.user_id + '/events', function(result) {
            that.events = result;
            that.calculateCurrentBalance();
          });
        });
        $.get('/api/v1/users/' + that.account.user_id + '/tags', function(result) {
          that.tags = result;
          console.log(that.tags);
        });
      });
    },
    computed: {
      sortedExpenses: function() {
        return this.expenses.sort(function(date1, date2) {
          
          return date2['date'].localeCompare(date1['date']);
          
        }.bind(this));
      }
    },
    methods: {
      calculateCurrentBalance: function() {
        var that = this;
        that.currentBalance = parseInt(that.lastBalance);
        var today = new Date();
        for (var i = 0; i < that.expenses.length; i++) {
          var expenseDate = new Date(that.expenses[i].date);
          var balanceUpdateTime = new Date(that.account.balance_update_time);
          if (expenseDate < today && expenseDate > balanceUpdateTime ) {
            that.currentBalance += parseInt(that.expenses[i].amount);
          }
        }

        for (var j = 0; j < that.events.length; j++) {
          var eventDate = new Date(that.events[j].date);
          var balanceUpdateTime2 = new Date(that.account.balance_update_time);
          if (eventDate < today && eventDate > balanceUpdateTime2 ) {
            that.currentBalance += parseInt(that.events[j].amount);
          }
          that.pmPercentage = that.pocketMoney / that.currentBalance;
          that.pmPercentage = JSON.stringify(that.pmPercentage * 100) + "%";

        }
        console.log(that.currentBalance);
      },
      updateAccount: function() {
        var that = this;
        var params = {last_balance: that.lastBalance, pocket_time: that.pocketTime};
        $.ajax({
          url: '/api/v1/accounts/' + that.accountID + '.json',
          type: 'PATCH',
          data: params,
          success: function(result) {
            console.log('I am the updated balance object');
            console.log(result);
            //that.account = result;
            console.log("I'm the currentBalance after the update");
            that.currentBalance = result.last_balance;
            console.log(that.currentBalance);
            that.pocketMoney = result.pocket_money;
            app.$forceUpdate();

          }
        });
      },
      addExpense: function(amount, tagID, impact) {
        var that = this;
        if (that.newExpImpact === "out") {
          var currentAmount = -1 * parseInt(amount);
        } else {
          currentAmount = amount;
        }
        var params = {amount: currentAmount, tag_id: tagID, user_id: that.userId, date: new Date(), impact: impact};
        $.post('/api/v1/expenses', params, function(result) {
          that.newExpense = result;
          that.account = result.account;
          that.pocketMoney += parseInt(currentAmount);
          that.currentBalance += parseInt(currentAmount);
          that.tagID = 0;
          that.newExpAmount = null;
          that.expenses.push(that.newExpense);
        });
      },
      addNewTag: function(description) {
        if (this.newTagDescription !== "") {
          var params = {description: description, user_id: this.userId };
          $.post('/api/v1/tags', params, function(result) {
            this.tags.push(result);
            this.tagAccount = result.account;
          }.bind(this));
          this.newTagDescription = null;
          console.log(this.tags);
        }
      },
      newTag: function() {
        this.newTagForm = !this.newTagForm;
        return this.newTagForm;
      },
      sortExpenses: function() {

        this.expenses.sort(function(expense1, expense2) {
          // if false flips the order
          return expense1.date > expense2.date;
        });
      },
      deleteExpense: function(id, amount) {
        var that = this;
        $.ajax({
          url: '/api/v1/expenses/' + id + '/delete.json',
          type: 'DELETE',
          success: function(result) {
            that.expenses = result;
            that.pocketMoney += parseInt(amount);
            that.currentBalance += parseInt(amount);

          }
        });
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
      unHideExpenseForm: function() {
        this.hideExpenseForm = !this.hideExpenseForm;
      },
      unHideAccountForm: function() {
        this.accountUpdateForm = !this.accountUpdateForm;
      },
      // numberToCurrency: function(number) {
      //   var moneyNumber = number.toFixed(2);
      //   moneyNumber = JSON.stringify(moneyNumber).replace(/\B(?=(\d{3})+(?!\d))/g, ",").replace('"', '').replace('"', '');
      //   return moneyNumber;
      // }
    }
  });
});

