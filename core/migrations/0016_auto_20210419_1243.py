# Generated by Django 2.2.14 on 2021-04-19 15:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0015_auto_20210419_1238'),
    ]

    operations = [
        migrations.AlterField(
            model_name='item',
            name='category',
            field=models.CharField(choices=[('J', 'Jabones'), ('C', 'Cremas'), ('S', 'Shampoo'), ('E', 'Emulsiones')], max_length=2),
        ),
    ]
