# Generated by Django 2.2.14 on 2021-04-19 14:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_auto_20210419_1148'),
    ]

    operations = [
        migrations.AlterField(
            model_name='item',
            name='category',
            field=models.CharField(choices=[('J', 'Jabon'), ('C', 'Crema'), ('S', 'Shampoo')], max_length=2),
        ),
    ]
