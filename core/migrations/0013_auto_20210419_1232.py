# Generated by Django 2.2.14 on 2021-04-19 15:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0012_auto_20210419_1230'),
    ]

    operations = [
        migrations.AlterField(
            model_name='item',
            name='label',
            field=models.TextField(choices=[('Pr', 'primary'), ('S', 'secondary'), ('D', 'danger')], max_length=15),
        ),
    ]
