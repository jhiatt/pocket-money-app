function weeklyForm(weekly) {
  if (weekly === "false") {
    document.getElementById('weekly').classList.add('hidden');
    if (document.getElementById('monthly').classList.contains('hidden')) {
      document.getElementById('monthly').classList.remove('hidden');    
    }
  } else if (weekly === "true") {
    document.getElementById('monthly').classList.add('hidden');
    if (document.getElementById('weekly').classList.contains('hidden')) {
      document.getElementById('weekly').classList.remove('hidden');    
    }
  }
}

function addDateForm(element) {
  element.parentElement.nextElementSibling.classList.remove('hidden');
}