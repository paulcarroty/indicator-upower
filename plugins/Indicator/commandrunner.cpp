#include "commandrunner.h"

#include <QDebug>
#include <QThread>
#include <limits>

CommandRunner::CommandRunner(QObject *parent) :
    QObject(parent),
    m_process(newProcess())
{
}

QProcess* CommandRunner::newProcess()
{
    auto process = new QProcess();
    process->moveToThread(QThread::currentThread());

    connect(process, &QProcess::stateChanged, this, [=](QProcess::ProcessState state) {
        if (state == QProcess::NotRunning) {
            qDebug() << "Command stopped";
            if (process != this->m_process)
                process->deleteLater();
        }
    }, Qt::DirectConnection);
    connect(process, &QProcess::readyReadStandardError,
            this, [=]() {
        const QByteArray stdErrContent = process->readAllStandardError();
        qDebug() << stdErrContent;
        if (stdErrContent.contains("userpasswd")) {
            emit passwordRequested();
        }
    }, Qt::DirectConnection);
    return process;
}

int CommandRunner::shell(const QStringList &command, const bool waitForCompletion, QByteArray* output)
{
    QStringList cmd = QStringList{"-c", command.join(" ")};

    this->m_process->start("bash", cmd, QProcess::ReadWrite);
    if (!this->m_process->waitForStarted(5000)) {
        qDebug() << "Failed to start shell command";
        return -1;
    }

    if (waitForCompletion) {
        // Use reasonable timeout of 30 seconds instead of max int
        if (!this->m_process->waitForFinished(30000)) {
            qDebug() << "Shell command timed out";
            return -1;
        }
        if (output) {
            *output = this->m_process->readAllStandardOutput();
        }
        qDebug() << this->m_process->exitCode();
        const int ret = this->m_process->exitCode();
        return ret;
    }
    return -1;
}

int CommandRunner::sudo(const QStringList &command, const bool waitForCompletion, const bool separateProcess, QByteArray* output)
{
    QStringList cmd = QStringList{"-S", "-p", "userpasswd"} + command;
    qDebug() << "running" << cmd.join(" ");

    auto process = separateProcess ? newProcess() : m_process;

    process->start("sudo", cmd, QProcess::ReadWrite);
    if (!process->waitForStarted(5000)) {
        qDebug() << "Failed to start sudo command";
        return -1;
    }

    if (waitForCompletion) {
        // Use reasonable timeout of 30 seconds instead of max int
        if (!process->waitForFinished(30000)) {
            qDebug() << "Sudo command timed out";
            return -1;
        }
        if (output) {
            *output = process->readAllStandardOutput();
        }
        qDebug() << process->exitCode();
        const int ret = process->exitCode();
        return ret;
    }
    return -1;
}

bool CommandRunner::sudo(const QStringList &command)
{
    return sudo(command, true, false, nullptr);
}

QByteArray CommandRunner::readFile(const QString &absolutePath)
{
    sudo(QStringList{"cat" , absolutePath});
    if (!this->m_process->waitForFinished(5000)) {
        qDebug() << "Failed to read file:" << absolutePath;
        return QByteArray();
    }
    const QByteArray value = this->m_process->readAllStandardOutput();
    qDebug() << absolutePath << "=" << value;
    return value;
}

bool CommandRunner::writeFile(const QString &absolutePath, const QByteArray &value)
{
    const QStringList writeCommand {
        QStringLiteral("/bin/sh"), QStringLiteral("-c"),
        QStringLiteral("echo '%1' | tee %2").arg(value, absolutePath)
    };
    sudo(writeCommand);
    return (this->m_process->exitCode() == 0);
}

bool CommandRunner::rm(const QString& path)
{
    const QStringList writeCommand {
        QStringLiteral("/bin/sh"), QStringLiteral("-c"),
        QStringLiteral("/bin/rm '%1'").arg(path)
    };
    sudo(writeCommand);
    return (this->m_process->exitCode() == 0);
}

void CommandRunner::providePassword(const QString& password)
{
    this->m_process->write(password.toUtf8());
    this->m_process->write("\n");
}

bool CommandRunner::validatePassword()
{
    const QStringList idCommand {
        QStringLiteral("id"), QStringLiteral("-u")
    };
    sudo(idCommand);
    if (!this->m_process->waitForFinished(5000)) {
        qDebug() << "Password validation timed out";
        return false;
    }
    const QByteArray output = this->m_process->readAllStandardOutput();
    return (output.trimmed() == "0");
}

void CommandRunner::cancel()
{
    if (m_process->state() != QProcess::NotRunning) {
        m_process->terminate();
        if (!m_process->waitForFinished(3000)) {
            m_process->kill();
            m_process->waitForFinished(1000);
        }
    }
}
