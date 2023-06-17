select error from alarms where status=2 and error like 'value%';

or

select count(error) from alarms where status=2 and error like 'value%';
