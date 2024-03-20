Date.prototype.getWeekOfMonth = function () {
  var firstWeekday = new Date(this.getFullYear(), this.getMonth(), 1).getDay();
  var offsetDate = this.getDate() + firstWeekday - 1;
  return Math.floor(offsetDate / 7);
};

window.addEventListener('load', function () {
  const form = $('body .availability-form');

  function updateVisibility() {
    const recurType = form.find('.recur_type').val();

    form.find('.recur_options').toggleClass('hidden', !recurType.length);
    form.find('.recur_options_weekly').toggleClass('hidden', recurType !== 'weekly');
    form.find('.recur_options_monthly').toggleClass('hidden', recurType !== 'monthly');
    updateDates();
  }

  updateVisibility();

  function updateDates() {
    const startDate = form.find('.start_date').val();
    if (startDate) {
      const date = new Date(Date.parse(startDate));
      const recur_month = form.find('.recur_month');
      recur_month.find('[value="exact_day"]').text(`Every day ${date.getDate()} of the month`);
      recur_month.find('[value="nth_week"]').text(`Every week ${date.getWeekOfMonth()} ${date.toLocaleString('en-us', {weekday: 'long'})} of the month`);
      form.find('.recur_options_weekly').find(`[value="${date.getDay()}"]`).prop('checked', true);
    }
  }

  form.on('change', '.recur_type', updateVisibility);
  form.on('change', '.start_date', updateDates);
});