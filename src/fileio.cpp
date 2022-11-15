#include <QDir>
#include "fileio.h"

FileIO::FileIO(QObject *parent) : QObject(parent)
{
    isOpen = false;
}

FileIO::~FileIO()
{
    close();
}

bool FileIO::open(const QString& dir, const QString& fileName)
{
    if (fileName.isEmpty() || dir.isEmpty())
        return false;

    QDir mDir;
    if (!mDir.exists(dir))
        mDir.mkpath(dir);

    QString finalPath = QDir(dir).filePath(fileName);

    file = new QFile(finalPath);

    isOpen = file->open(QFile::Append);

    if(isOpen)
        fout = new QTextStream(file);
    else
        qErrnoWarning("FileIO Open failed");

    return isOpen;
}

bool FileIO::close()
{
    if (isOpen)
    {
        file->close();
        isOpen = false;
        return true;
    }
    else
        return false;

}

bool FileIO::write(const QString& data)
{
    if (!isOpen)
        return false;

    *fout << data;
    fout->flush();

    return true;
}
