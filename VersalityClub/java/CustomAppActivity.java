/****************************************************************************
**
** Copyright (C) 2018 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality Club.
**
** Versality Club is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality Club is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Foobar.  If not, see https://www.gnu.org/licenses/.
**
****************************************************************************/

package org.versalityclub;

import android.os.Bundle;
import android.content.Intent;
import org.pwf.qtonesignal.QOneSignalBinding;

public class CustomAppActivity extends org.qtproject.qt5.android.bindings.QtActivity {
    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.startService(new Intent(this, LocationService.class));
        QOneSignalBinding.onCreate(this, bundle);
    }
}
