
#include <QtQml>
#include <QStandardPaths>
#include <QCryptographicHash>
#include <QFile>
#include <QFileDevice>
#include <QDir>
#include <QApplication>
#include <QQmlApplicationEngine>

bool copy_or_replace(const QString& in_file, const QString& out_file) {
    if (QFile::exists(out_file)) {
        return true;
        /*
        if (!QFile::remove(out_file)) {
            qDebug() << "Failed to remove the preexisting file " << out_file << ".\n";
            return false;
        }
        */
    }

    if (!QFile::copy(in_file, out_file)) {
        qDebug() << "Failed to copy " << in_file << " to " << out_file << ".\n";
        return false;
    }

    constexpr QFileDevice::Permission permissions = (QFileDevice::Permission)(0
        | QFileDevice::Permission::ReadOwner
        | QFileDevice::Permission::WriteOwner
        | QFileDevice::Permission::ReadGroup
        | QFileDevice::Permission::WriteGroup
        | QFileDevice::Permission::ReadUser
        | QFileDevice::Permission::WriteUser
        );

    if (!QFile::setPermissions(out_file, permissions)) {
        qDebug() << "Failed to set file permissions for " << out_file << ".\n";
        return false;
    }

    return true;
}

bool init_database() {
    const QString&& in_file = ":/FoodData";
    const QString&& in_db = in_file + ".db";
    const QString&& in_cfg = in_file + ".ini";
    constexpr QCryptographicHash::Algorithm hash_algo = QCryptographicHash::Md5;
    const QByteArray&& file_hash = QCryptographicHash::hash(QByteArray{"FoodData"}, hash_algo);
    const QString&& db_path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/QML/OfflineStorage/Databases/";
    const QString&& out_file = db_path + file_hash.toHex();

    const QDir db_dir;
    qDebug() << "Creating directory " << db_path << "...";
    if (!db_dir.mkpath(db_path)) {
        qDebug() << "Failed!\n";
        return false;
    }
    qDebug() << "Success!\n";

    const QString&& out_db = out_file + ".sqlite";
    const QString&& out_cfg = out_file + ".ini";

    qDebug() << "Relocating the food database...";
    qDebug() << "\tFrom:    " << in_db;
    qDebug() << "\tTo:      " << out_db;

    if (!copy_or_replace(in_db, out_db) || !copy_or_replace(in_cfg, out_cfg)) {
        qDebug() << "Failed!\n";
        return false;
    }

    qDebug() << "Success!\n";

    return true;
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.load(QUrl{QStringLiteral("qrc:/main.qml")});

    qDebug()
        << engine.offlineStoragePath()
        << " OR "
        << QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
        << '\n';
    if (!init_database()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
